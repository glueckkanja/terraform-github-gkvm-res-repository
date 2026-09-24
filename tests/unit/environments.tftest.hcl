mock_provider "github" {}

variables {
  name = "unit-repo"
}

run "creates_environment_with_policies_secrets_and_variables" {
  command = plan

  variables {
    environments = [{
      name       = "prod"
      wait_timer = 30
      deployment_branch_policy = {
        protected_branches     = false
        custom_branch_policies = true
      }
      deployment_policies = [
        { branch_pattern = "main" },
        { tag_pattern = "v*" },
      ]
      secrets   = [{ name = "TOKEN", value = "x" }]
      variables = [{ name = "REGION", value = "eu" }]
    }]
  }

  assert {
    condition     = keys(output.environments) == ["prod"]
    error_message = "environments must be keyed by name"
  }

  assert {
    condition     = toset(keys(output.environments["prod"].deployment_policies)) == toset(["branch-main", "tag-v*"])
    error_message = "deployment policies must be keyed <branch|tag>-<pattern>; this key is a state address"
  }

  assert {
    condition     = output.environments["prod"].variables["REGION"].value == "eu"
    error_message = "environment variables must be keyed by name and carry their value"
  }

  assert {
    condition     = keys(output.environments["prod"].secrets) == ["TOKEN"]
    error_message = "environment secrets must be exposed as metadata keyed by name"
  }

  assert {
    condition     = output.environments["prod"].resource.wait_timer == 30
    error_message = "wait_timer must be passed through"
  }
}

run "rejects_policies_without_custom_branch_policies" {
  command = plan

  variables {
    environments = [{
      name = "prod"
      deployment_branch_policy = {
        protected_branches     = true
        custom_branch_policies = false
      }
      deployment_policies = [{ branch_pattern = "main" }]
    }]
  }

  expect_failures = [var.environments]
}

run "rejects_policy_with_both_patterns" {
  command = plan

  variables {
    environments = [{
      name = "prod"
      deployment_branch_policy = {
        protected_branches     = false
        custom_branch_policies = true
      }
      deployment_policies = [{ branch_pattern = "main", tag_pattern = "v*" }]
    }]
  }

  expect_failures = [var.environments]
}

run "rejects_wait_timer_out_of_range" {
  command = plan

  variables {
    environments = [{ name = "prod", wait_timer = 50000 }]
  }

  expect_failures = [var.environments]
}

run "rejects_more_than_six_reviewers" {
  command = plan

  variables {
    environments = [{
      name = "prod"
      reviewers = {
        teams = [1, 2, 3, 4]
        users = [5, 6, 7]
      }
    }]
  }

  expect_failures = [var.environments]
}

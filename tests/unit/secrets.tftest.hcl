# Secrets and variables: type routing, state-address keys and the input
# validations that protect them.
mock_provider "github" {}

variables {
  name = "unit-repo"
}

run "routes_each_type_to_its_resource" {
  command = plan

  variables {
    secrets = [
      { name = "TOKEN", value = "x" },
      { name = "NPM", type = "dependabot", value = "y" },
      { name = "CS", type = "codespaces", value = "z" },
      { name = "REGION", is_variable = true, value = "eu" },
    ]
  }

  assert {
    condition     = toset(keys(output.secrets)) == toset(["actions-token", "dependabot-npm", "codespaces-cs", "actions-region"])
    error_message = "secrets must be keyed <type>-<lowercase name>; this key is a state address"
  }

  assert {
    condition     = output.secrets["actions-region"].is_variable && !output.secrets["actions-token"].is_variable
    error_message = "is_variable must route to github_actions_variable instead of a secret"
  }

  assert {
    condition     = output.secrets["dependabot-npm"].type == "dependabot" && output.secrets["codespaces-cs"].type == "codespaces"
    error_message = "the secret type must be carried through to the output"
  }
}

run "rejects_value_and_value_encrypted_together" {
  command = plan

  variables {
    secrets = [{ name = "A", value = "x", value_encrypted = "y" }]
  }

  expect_failures = [var.secrets]
}

run "rejects_encrypted_without_key_id" {
  command = plan

  variables {
    secrets = [{ name = "A", value_encrypted = "y" }]
  }

  expect_failures = [var.secrets]
}

run "allows_encrypted_codespaces_secret_without_key_id" {
  command = plan

  variables {
    secrets = [{ name = "A", type = "codespaces", value_encrypted = "y" }]
  }

  assert {
    condition     = length(output.secrets) == 1
    error_message = "codespaces secrets do not take a key_id"
  }
}

run "rejects_encrypted_variable" {
  command = plan

  variables {
    secrets = [{ name = "A", is_variable = true, value_encrypted = "y" }]
  }

  expect_failures = [var.secrets]
}

run "rejects_duplicate_names_case_insensitively" {
  command = plan

  variables {
    secrets = [
      { name = "Token", value = "x" },
      { name = "TOKEN", value = "y" },
    ]
  }

  expect_failures = [var.secrets]
}

mock_provider "github" {}

variables {
  name = "unit-repo"
}

run "creates_ruleset_from_object" {
  command = plan

  variables {
    repository_rulesets = [{
      name        = "protect-main"
      enforcement = "active"
      target      = "branch"
      conditions = {
        ref_name = {
          include = ["~DEFAULT_BRANCH"]
          exclude = []
        }
      }
      rules = {
        deletion         = true
        non_fast_forward = true
      }
    }]
  }

  assert {
    condition     = keys(output.rulesets) == ["protect-main"]
    error_message = "rulesets must be keyed by name"
  }

  assert {
    condition     = output.rulesets["protect-main"].enforcement == "active" && output.rulesets["protect-main"].target == "branch"
    error_message = "enforcement and target must be passed through"
  }

  assert {
    condition     = output.rulesets["protect-main"].rules[0].deletion && output.rulesets["protect-main"].rules[0].non_fast_forward
    error_message = "rules must be rendered from the rules object"
  }
}

run "rejects_unknown_enforcement" {
  command = plan

  variables {
    repository_rulesets = [{ name = "r", enforcement = "maybe", target = "branch" }]
  }

  expect_failures = [var.repository_rulesets]
}

run "rejects_duplicate_ruleset_names" {
  command = plan

  variables {
    repository_rulesets = [
      { name = "r", enforcement = "active", target = "branch" },
      { name = "r", enforcement = "active", target = "tag" },
    ]
  }

  expect_failures = [var.repository_rulesets]
}

run "files_are_keyed_by_path" {
  command = plan

  variables {
    files = [
      { file = ".github/CODEOWNERS", content = "* @glueckkanja/owners" },
      { file = "README.md", content = "# hello", commit_message = "docs: seed readme" },
    ]
  }

  assert {
    condition     = toset(keys(output.files)) == toset([".github/CODEOWNERS", "README.md"])
    error_message = "files must be keyed by path; this key is a state address"
  }

  assert {
    condition     = output.files["README.md"].commit_message == "docs: seed readme" && output.files["README.md"].overwrite_on_create
    error_message = "file attributes must be passed through, overwrite_on_create defaults to true"
  }
}

run "custom_properties_by_type" {
  command = plan

  variables {
    custom_properties = [
      { name = "team", value = ["platform"] },
      { name = "tags", type = "multi_select", value = ["a", "b"] },
      { name = "critical", type = "true_false", value = ["true"] },
    ]
  }

  assert {
    condition     = toset(keys(output.custom_properties)) == toset(["team", "tags", "critical"])
    error_message = "custom properties must be keyed by name"
  }

  assert {
    condition     = output.custom_properties["team"].type == "string" && output.custom_properties["tags"].type == "multi_select"
    error_message = "type defaults to string and is passed through otherwise"
  }

  assert {
    condition     = contains(output.custom_properties["tags"].value, "a") && contains(output.custom_properties["tags"].value, "b")
    error_message = "multi_select values must all be set"
  }
}

run "rejects_unknown_property_type" {
  command = plan

  variables {
    custom_properties = [{ name = "p", type = "number", value = ["1"] }]
  }

  expect_failures = [var.custom_properties]
}

run "rejects_multiple_values_for_single_value_type" {
  command = plan

  variables {
    custom_properties = [{ name = "p", value = ["a", "b"] }]
  }

  expect_failures = [var.custom_properties]
}

run "rejects_non_boolean_true_false_value" {
  command = plan

  variables {
    custom_properties = [{ name = "p", type = "true_false", value = ["yes"] }]
  }

  expect_failures = [var.custom_properties]
}

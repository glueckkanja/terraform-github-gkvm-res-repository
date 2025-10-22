# Github Repository Ruleset Module

This module is used to manage rulesets within a GitHub repository.

## Features

This module supports managing rulesets in a GitHub repository, including creating, updating, and deleting rulesets.

The module supports:

- Creating a new ruleset

## Usage

To use this module in your Terraform configuration, you'll need to provide values for the required variables.

### Example - Basic Ruleset Creation

This example shows the most basic usage of the module. It creates a new ruleset in the repository.

```terraform
module "ruleset_creation" {
  source = "glueckkanja/terraform-azurerm-avm-res-network-virtualnetwork//modules/ruleset"

  name       = "example-ruleset"
  repository = "Example Repository"
  target     = "branch"
  enforcement = "active"

  rules = {
    pull_request = {
      require_code_owner_review = true
    }
  }

  bypass_actors = [
    {
      actor_id    = 396065
      actor_type  = "Integration"
      bypass_mode = "always"
    }
  ]

  conditions = {
    ref_name = {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }
}
```

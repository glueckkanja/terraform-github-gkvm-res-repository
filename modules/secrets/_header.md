# Github Repository Secrets Module

This module is used to manage secrets within a GitHub repository.

## Features

This module supports managing secrets in a GitHub repository, including creating, updating, and deleting secrets.

The module supports:

- Creating a new actions secret
- Creating a new actions variable
- Creating a new Codespaces secret
- Creating a new Dependabot secret

## Usage

To use this module in your Terraform configuration, you'll need to provide values for the required variables.

### Example - Basic Action Secret Creation

This example shows the most basic usage of the module. It creates a new actions secret in the repository.

```terraform
module "actions_secret_creation" {
  source = "glueckkanja/terraform-azurerm-avm-res-network-virtualnetwork//modules/secrets"

  name            = "example-actions-secret"
  repository      = "Example Repository"
  plaintext_value = "My$ecretV@lue"
  type            = "actions"
}
```

### Example - Basic Codespaces Secret Creation

```terraform
module "codespaces_secret_creation" {
  source = "glueckkanja/terraform-azurerm-avm-res-network-virtualnetwork//modules/secrets"

  name            = "example-codespaces-secret"
  repository      = "Example Repository"
  plaintext_value = "My$ecretV@lue"
  type            = "codespaces"
}
```

### Example - Basic Dependabot Secret Creation

```terraform
module "dependabot_secret_creation" {
  source = "glueckkanja/terraform-azurerm-avm-res-network-virtualnetwork//modules/secrets"

  name            = "example-dependabot-secret"
  repository      = "Example Repository"
  plaintext_value = "My$ecretV@lue"
  type            = "dependabot"
}
```

### Example - Basic Action Variable Creation

```terraform
module "actions_variable_creation" {
  source = "glueckkanja/terraform-azurerm-avm-res-network-virtualnetwork//modules/secrets"

  name            = "example-actions-variable"
  repository      = "Example Repository"
  plaintext_value = "My$ecretV@lue"
  type            = "actions"
  is_variable     = true
}
```

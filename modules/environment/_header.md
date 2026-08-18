# GitHub Repository Environment Module

This module manages a deployment environment within a GitHub repository, together with its protection rules, deployment branch and tag policies, and environment-scoped Actions secrets and variables.

## Features

- Required reviewers, a wait timer, admin bypass and self-review prevention
- Deployment branch policies, either "protected branches only" or custom branch and tag patterns
- Environment-scoped Actions secrets, supplied in plaintext or pre-encrypted
- Environment-scoped Actions variables

## Usage

### Example - Basic environment

```terraform
module "environment" {
  source = "glueckkanja/gkvm-res-repository/github//modules/environment"

  name       = "staging"
  repository = "example-repository"
}
```

### Example - Protected production environment

This environment requires review, waits five minutes before deploying, and only allows deployments from branches matching `main` or `releases/*`.

```terraform
module "environment" {
  source = "glueckkanja/gkvm-res-repository/github//modules/environment"

  name       = "production"
  repository = "example-repository"

  wait_timer          = 5
  prevent_self_review = true
  can_admins_bypass   = false

  reviewers = {
    users = [1234567]
    teams = [7654321]
  }

  deployment_branch_policy = {
    protected_branches     = false
    custom_branch_policies = true
  }

  deployment_policies = [
    { branch_pattern = "main" },
    { branch_pattern = "releases/*" },
    { tag_pattern = "v*" },
  ]

  secrets = [
    { name = "DEPLOY_TOKEN", value = "s3cr3t" },
  ]

  variables = [
    { name = "TARGET_REGION", value = "westeurope" },
  ]
}
```

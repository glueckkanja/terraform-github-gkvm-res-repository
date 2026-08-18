terraform {
  required_version = "~> 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }
}

provider "github" {}

module "repository" {
  source = "../../"

  name      = "Example Repository"
  auto_init = false
  default_branch = {
    branch = "main"
    rename = false
  }
  description      = "This is an example repository."
  has_issues       = true
  has_projects     = true
  has_wiki         = true
  license_template = "mit"
  visibility       = "public"

  environments = [
    {
      name = "staging"
    },
    {
      name                = "production"
      wait_timer          = 5
      prevent_self_review = true
      can_admins_bypass   = false

      deployment_branch_policy = {
        protected_branches     = false
        custom_branch_policies = true
      }

      deployment_policies = [
        { branch_pattern = "main" },
        { tag_pattern = "v*" },
      ]

      variables = [
        { name = "TARGET_REGION", value = "westeurope" },
      ]
    },
  ]
}

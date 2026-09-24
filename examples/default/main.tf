terraform {
  required_version = "~> 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "github" {}

# The end-to-end test applies this example for real and destroys it again, so
# the repository name has to be unique per run: a fixed name collides between
# concurrent runs, and a leftover from a cancelled run would block the next
# one. The gkvm-e2e- prefix makes any leftover recognisable.
resource "random_string" "suffix" {
  length  = 6
  lower   = true
  numeric = true
  special = false
  upper   = false
}

module "repository" {
  source = "../../"

  name      = "gkvm-e2e-default-${random_string.suffix.result}"
  auto_init = false
  default_branch = {
    branch = "main"
    rename = false
  }
  description = "This is an example repository."
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
  has_issues       = true
  has_projects     = true
  has_wiki         = true
  license_template = "mit"
  visibility       = "public"
}

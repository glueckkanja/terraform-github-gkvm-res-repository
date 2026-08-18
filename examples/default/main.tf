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
}

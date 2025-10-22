terraform {
  required_version = "~> 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.6"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }
}

provider "github" {}

provider "modtm" {
  enabled = false
}

module "repository" {
  source = "../../"

  name      = "Example Repository"
  auto_init = false
  default_branch = {
    branch = "main"
    rename = false
  }
  description      = "This is an example repository."
  enable_telemetry = var.enable_telemetry
  has_downloads    = true
  has_issues       = true
  has_projects     = true
  has_wiki         = true
  license_template = "mit"
  visibility       = "public"
}

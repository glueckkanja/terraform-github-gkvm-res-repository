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

locals {
  property_name = "azere-managed"
}

# ---------------------------------------------------------------------------
# 1. The organization property definition.
#
# This is an organization-wide singleton and is shown here only to make the
# example readable. Declare it once, in the configuration that owns
# organization settings -- never in a per-repository module, where every
# consuming state would claim ownership of the same object.
#
# `values_editable_by = "org_actors"` is the setting that makes this worth
# doing: it prevents repository administrators from editing their own
# property value to drop out of the ruleset below.
# ---------------------------------------------------------------------------
resource "github_organization_custom_properties" "managed" {
  property_name      = local.property_name
  value_type         = "true_false"
  required           = false
  values_editable_by = "org_actors"
}

# ---------------------------------------------------------------------------
# 2. The repository, stamped with the property.
# ---------------------------------------------------------------------------
module "repository" {
  source = "../../"

  name        = "example-customer-repository"
  description = "Created and labelled by the onboarding stack."
  visibility  = "private"
  auto_init   = true

  default_branch = {
    branch = "main"
  }

  files = [
    {
      file           = "README.md"
      content        = "# Example customer repository\n"
      commit_message = "chore: seed repository"
    },
  ]

  custom_properties = [
    {
      name  = local.property_name
      type  = "true_false"
      value = ["true"]
    },
  ]

  depends_on = [github_organization_custom_properties.managed]
}

# ---------------------------------------------------------------------------
# 3. The organization ruleset, selecting by property rather than by name.
#
# Repository administrators cannot edit this. Adding a repository to its scope
# is done by stamping the property, not by editing a name list here.
# ---------------------------------------------------------------------------
resource "github_organization_ruleset" "default_branch" {
  name        = "protect-default-branch-on-managed-repos"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }

    repository_property {
      include {
        name            = local.property_name
        property_values = ["true"]
      }
    }
  }

  # The onboarding app keeps pushing once the rule is armed. This is the
  # durable exclusion; the module's internal ordering is only convenience.
  bypass_actors {
    actor_id    = 12345
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      required_approving_review_count   = 1
      require_last_push_approval        = true
      required_review_thread_resolution = true
    }
  }

  depends_on = [github_organization_custom_properties.managed]
}

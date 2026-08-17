variable "name" {
  type        = string
  description = "The name of the repository."
  nullable    = false
}

variable "allow_auto_merge" {
  type        = bool
  default     = false
  description = "Whether to allow auto-merge on pull requests."
  nullable    = false
}

variable "allow_merge_commit" {
  type        = bool
  default     = true
  description = "Whether to allow merge commits on pull requests."
  nullable    = false
}

variable "allow_rebase_merge" {
  type        = bool
  default     = true
  description = "Whether to allow rebase merges on pull requests."
  nullable    = false
}

variable "allow_squash_merge" {
  type        = bool
  default     = true
  description = "Whether to allow squash merges on pull requests."
  nullable    = false
}

variable "allow_update_branch" {
  type        = bool
  default     = false
  description = "(Optional) Set to true to always suggest updating pull request branches. Defaults to false."
  nullable    = false
}

variable "archive_on_destroy" {
  type        = bool
  default     = false
  description = "(Optional) Set to true to archive the repository instead of deleting on destroy."
  nullable    = false
}

variable "archived" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
(Optional) Specifies if the repository should be archived. Defaults to false. **NOTE** Currently, the API does not support unarchiving.
DESCRIPTION
  nullable    = false
}

variable "auto_init" {
  type        = bool
  default     = false
  description = "Whether to create an initial commit with empty README."
  nullable    = false
}

variable "default_branch" {
  type = object({
    branch = string
    rename = optional(bool, false)
  })
  default     = null
  description = <<DESCRIPTION
This setting allows you to set the default branch. Set this to `null` to leave the default branch unchanged.

`branch` - (Required) The name of the branch to set as the default branch.
`rename` - (Optional) Whether to rename the default branch if it already exists. Defaults to `false`.
DESCRIPTION
}

variable "delete_branch_on_merge" {
  type        = bool
  default     = false
  description = "Whether to delete head branches when pull requests are merged."
  nullable    = false
}

variable "description" {
  type        = string
  default     = null
  description = "A short description of the repository."
}

variable "files" {
  type = list(object({
    content = string
    file    = string

    autocreate_branch               = optional(bool, false)
    autocreate_branch_source_branch = optional(string, null)
    autocreate_branch_source_sha    = optional(string, null)
    # branch                          = optional(string, null)
    commit_author       = optional(string, null)
    commit_email        = optional(string, null)
    commit_message      = optional(string, null)
    overwrite_on_create = optional(bool, true)
  }))
  default     = []
  description = "(Optional) A list of files to create or update in the repository."
  nullable    = false
}

variable "gitignore_template" {
  type        = string
  default     = null
  description = <<DESCRIPTION
The .gitignore template to apply. For a list of possible values, see the GitHub API documentation.
Use the name of the template without the extension.
For example, use `Haskell` for the `Haskell.gitignore` template.
DESCRIPTION
}

variable "has_discussions" {
  type        = bool
  default     = false
  description = "(Optional) Set to `true` to enable GitHub Discussions on the repository. Defaults to `false`."
}

variable "has_issues" {
  type        = bool
  default     = true
  description = "Whether issues are enabled."
  nullable    = false
}

variable "has_projects" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
(Optional) Set to `true` to enable the GitHub Projects features on the repository.
Per the GitHub documentation when in an organization that has disabled repository projects it will default to `false` and will otherwise default to `true`.
If you specify `true` when it has been disabled it will return an error.
DESCRIPTION
}

variable "has_wiki" {
  type        = bool
  default     = true
  description = "Whether the wiki is enabled."
  nullable    = false
}

variable "homepage_url" {
  type        = string
  default     = null
  description = "A URL with more information about the repository."
}

variable "is_template" {
  type        = bool
  default     = false
  description = "(Optional) Set to `true` to tell GitHub that this is a template repository."
}

variable "license_template" {
  type        = string
  default     = null
  description = <<DESCRIPTION
The license template to apply. For a list of possible values, see the GitHub API documentation.
Use the name of the template without the extension.
For example, use `mit` for the `MIT.txt` template.
DESCRIPTION
}

variable "merge_commit_message" {
  type        = string
  default     = null
  description = <<DESCRIPTION
Can be PR_BODY, PR_TITLE, or BLANK for a default merge commit message. Applicable only if allow_merge_commit is true.
DESCRIPTION

  validation {
    condition     = var.merge_commit_message == null || (var.merge_commit_message == "PR_BODY" && var.allow_merge_commit == true) || (var.merge_commit_message == "PR_TITLE" && var.allow_merge_commit == true) || (var.merge_commit_message == "BLANK" && var.allow_merge_commit == true)
    error_message = "The merge_commit_message variable must be either 'PR_BODY', 'PR_TITLE', 'BLANK' or null. If using 'PR_BODY', 'PR_TITLE' or 'BLANK' then allow_merge_commit must be set to true."
  }
}

variable "merge_commit_title" {
  type        = string
  default     = null
  description = <<DESCRIPTION
Can be PR_TITLE or MERGE_MESSAGE for a default merge commit title. Applicable only if allow_merge_commit is true.
DESCRIPTION

  validation {
    condition     = var.merge_commit_title == null || (var.merge_commit_title == "PR_TITLE" && var.allow_merge_commit == true) || (var.merge_commit_title == "MERGE_MESSAGE" && var.allow_merge_commit == true)
    error_message = "The merge_commit_title variable must be either 'PR_TITLE', 'MERGE_MESSAGE' or null. If using 'PR_TITLE' or 'MERGE_MESSAGE' then allow_merge_commit must be set to true."
  }
}

variable "pages" {
  type = object({
    source = optional(object({
      branch = string
      path   = optional(string, null)
    }), null)
    build_type = optional(string, null)
    cname      = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
(Optional) The repository's GitHub Pages configuration. Set to `null` to disable GitHub Pages.
If omitted, GitHub Pages will not be configured.

`source` - (Optional) The source configuration for GitHub Pages.
  `branch` - (Required) The branch to use for GitHub Pages.
  `path` - (Optional) The path to use for GitHub Pages. Can be `/` for the root or `/docs` for the docs folder.
`build_type` - (Optional) The build type to use for GitHub Pages. Can be `legacy` or `source`. If you use legacy as build type you need to set the option source.
`cname` - (Optional) The custom domain name to use for GitHub Pages.
DESCRIPTION
}

variable "repository_rulesets" {
  type = list(object({
    enforcement = string
    name        = string
    target      = string
    bypass_actors = optional(list(object({
      actor_id    = number
      actor_type  = string
      bypass_mode = string
    })), [])
    conditions = optional(object({
      ref_name = object({
        include = list(string)
        exclude = list(string)
      })
    }), null)
    rules = optional(object({
      branch_name_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, false)
      }), null)
      commit_author_email_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, false)
      }), null)
      commit_message_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, false)
      }), null)
      committer_email_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, false)
      }), null)
      creation         = optional(bool, false)
      update           = optional(bool, false)
      deletion         = optional(bool, false)
      non_fast_forward = optional(bool, false)
      merge_queue = optional(object({
        check_response_timeout_minutes    = optional(number, 60)
        grouping_strategy                 = optional(string, "ALLGREEN")
        max_entries_to_build              = optional(number, 5)
        max_entries_to_merge              = optional(number, 5)
        merge_method                      = optional(string, "MERGE")
        min_entries_to_merge              = optional(number, 1)
        min_entries_to_merge_wait_minutes = optional(number, 5)
      }), null)
      pull_request = optional(object({
        dismiss_stale_reviews_on_push     = optional(bool, false)
        require_code_owner_review         = optional(bool, false)
        require_last_push_approval        = optional(bool, false)
        required_approving_review_count   = optional(number, 0)
        required_review_thread_resolution = optional(bool, false)
      }), null)
      required_deployments = optional(object({
        required_deployment_environments = list(string)
      }), null)
      required_linear_history = optional(bool, false)
      required_signatures     = optional(bool, false)
      required_status_checks = optional(object({
        required_check = list(object({
          context        = string
          integration_id = optional(number, null)
        }))
        strict_required_status_checks_policy = optional(bool, false)
        do_not_enforce_on_create             = optional(bool, false)
      }), null)
      tag_name_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, false)
      }), null)
      required_code_scanning = optional(object({
        required_code_scanning_tool = list(object({
          alerts_threshold          = string
          security_alerts_threshold = string
          tool                      = string
        }))
      }), null)
      update_allows_fetch_and_merge = optional(bool, false)
    }), {})
  }))
  default     = []
  description = <<DESCRIPTION
(Optional) A list of rulesets to apply to the repository. Each object supports the following attributes:

- `enforcement` - (Required) Possible values are `disabled`, `active`, `evaluate`. Note: `evaluate` is only supported for owners of type organization.
- `name` - (Required) The name of the ruleset.
- `target` - (Required) The type of ref that the ruleset applies to. Can be one of: `branch`, `tag`.
- `bypass_actors` - (Optional) Actors that can bypass the ruleset. Defaults to `[]`.
  - `actor_id` - (Required) The ID of the actor that can bypass the ruleset. For a user, this is their user ID. For a team, this is the team's node ID. For an app, this is the app's ID.
  - `actor_type` - (Required) Can be one of: `RepositoryRole`, `Team`, `Integration` and `OrganizationAdministrator`.
  - `bypass_mode` - (Required) Can be one of: `always`, `pull_request`.
- `conditions` - (Optional) Conditions that must be met for the ruleset to apply. Defaults to `null`.
  - `ref_name.include` - (Required) A list of reference names that must be included.
  - `ref_name.exclude` - (Required) A list of reference names that must be excluded.
- `rules` - (Optional) Rules within the ruleset. Defaults to `{}`. See the `ruleset` submodule documentation for the full attribute reference.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for r in var.repository_rulesets : contains(["disabled", "active", "evaluate"], r.enforcement)])
    error_message = "Each ruleset 'enforcement' must be one of 'disabled', 'active', or 'evaluate'."
  }

  validation {
    condition     = alltrue([for r in var.repository_rulesets : contains(["branch", "tag"], r.target)])
    error_message = "Each ruleset 'target' must be one of 'branch' or 'tag'."
  }

  validation {
    condition     = length(distinct([for r in var.repository_rulesets : r.name])) == length(var.repository_rulesets)
    error_message = "Each ruleset 'name' must be unique."
  }
}

variable "secrets" {
  type = list(object({
    name            = string
    encrypted_value = optional(string, null)
    plaintext_value = optional(string, null)
    type            = optional(string, "actions")
    is_variable     = optional(bool, false)
  }))
  default     = []
  description = <<DESCRIPTION
(Optional) A list of secrets or variables to create in the repository.

**NOTE:** entries are keyed by `type` and `name`, case-insensitively. Two entries
that share a `type` and a case-insensitive `name` are rejected, even when one is a
secret and the other an Actions variable. GitHub itself treats secrets and variables
as separate namespaces, so if you need `FOO` as both, declare the variable with a
separate `github_actions_variable` resource outside this module.
DESCRIPTION
  nullable    = false

  validation {
    condition = length(distinct([
      for s in var.secrets : format("%s-%s", lower(s.type), lower(s.name))
    ])) == length(var.secrets)
    error_message = "Each secret must be unique by the combination of 'type' and 'name' (compared case-insensitively). Note that an Actions secret and an Actions variable cannot share a name within this module."
  }
}

variable "security_and_analysis" {
  type = object({
    advanced_security = optional(object({
      status = string # Can be "enabled" or "disabled"
    }), null)
    secret_scanning = optional(object({
      status = string # Can be "enabled" or "disabled"
    }), null)
    secret_scanning_push_protection = optional(object({
      status = string # Can be "enabled" or "disabled"
    }), null)
  })
  default     = null
  description = <<DESCRIPTION
(Optional) The repository's security and analysis settings.
`advanced_security` - (Optional) The advanced security settings for the repository.
  `status` - (Required) The status of advanced security. Can be `enabled` or `disabled`.
`secret_scanning` - (Optional) The secret scanning settings for the repository.
  `status` - (Required) The status of secret scanning. Can be `enabled` or `disabled`. If set to `enabled`, the repository's visibility must be `public` or `security_and_analysis[0].advanced_security[0].status` must also be set to `enabled`.
`secret_scanning_push_protection` - (Optional) The secret scanning push protection settings for the repository.
  `status` - (Required) The status of secret scanning push protection. Can be `enabled` or `disabled`. If set to `enabled`, the repository's visibility must be `public` or `security_and_analysis[0].advanced_security[0].status` must also be set to `enabled`.
DESCRIPTION
}

variable "squash_merge_commit_message" {
  type        = string
  default     = null
  description = <<DESCRIPTION
(Optional) Can be PR_BODY, COMMIT_MESSAGES, or BLANK for a default squash merge commit message.
Applicable only if allow_squash_merge is true.
DESCRIPTION

  validation {
    condition     = var.squash_merge_commit_message == null || (var.squash_merge_commit_message == "PR_BODY" && var.allow_squash_merge == true) || (var.squash_merge_commit_message == "COMMIT_MESSAGES" && var.allow_squash_merge == true) || (var.squash_merge_commit_message == "BLANK" && var.allow_squash_merge == true)
    error_message = "The squash_merge_commit_message variable must be either 'PR_BODY', 'COMMIT_MESSAGES', 'BLANK' or null. If using 'PR_BODY', 'COMMIT_MESSAGES' or 'BLANK' then allow_squash_merge must be set to true."
  }
}

variable "squash_merge_commit_title" {
  type        = string
  default     = null
  description = <<DESCRIPTION
(Optional) Can be PR_TITLE or COMMIT_OR_PR_TITLE for a default squash merge commit title.
Applicable only if allow_squash_merge is true.
DESCRIPTION

  validation {
    condition     = var.squash_merge_commit_title == null || (var.squash_merge_commit_title == "PR_TITLE" && var.allow_squash_merge == true) || (var.squash_merge_commit_title == "COMMIT_OR_PR_TITLE" && var.allow_squash_merge == true)
    error_message = "The squash_merge_commit_title variable must be either 'PR_TITLE', 'COMMIT_OR_PR_TITLE' or null. If using 'PR_TITLE' or 'COMMIT_OR_PR_TITLE' then allow_squash_merge must be set to true."
  }
}

variable "template" {
  type = object({
    owner                = string
    repository           = string
    include_all_branches = optional(bool, false)
  })
  default     = null
  description = <<DESCRIPTION
(Optional) Use a template repository to create this resource.

`owner` - (Required) The owner of the template repository. The owner can be a user or an organization.
`repository` - (Required) The name of the template repository.
`include_all_branches` - (Optional) Whether to include all branches from the template repository. Defaults to `false`, which only includes the default branch.
DESCRIPTION
}

variable "visibility" {
  type        = string
  default     = null
  description = <<DESCRIPTION
Can be `public` or `private`. If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+,
visibility can also be `internal`. The visibility parameter overrides the private parameter.
DESCRIPTION

  validation {
    condition     = var.visibility == null || var.visibility == "public" || var.visibility == "private" || var.visibility == "internal"
    error_message = "The visibility variable must be either 'public', 'private', 'internal' or null."
  }
}

variable "vulnerability_alerts" {
  type        = bool
  default     = false
  description = "(Optional) Set to `true` to enable vulnerability alerts on the repository. Defaults to `false`."
  nullable    = false
}

variable "web_commit_signoff_required" {
  type        = bool
  default     = false
  description = "Whether to require contributors to sign off on web-based commits."
  nullable    = false
}

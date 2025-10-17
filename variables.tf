variable "name" {
  type        = string
  description = "The name of the repository."
  nullable    = false
}

variable "description" {
  type        = string
  description = "A short description of the repository."
  nullable    = true
  default     = null
}

variable "homepage_url" {
  type        = string
  description = "A URL with more information about the repository."
  nullable    = true
  default     = null
}

variable "visibility" {
  type        = string
  description = <<DESCRIPTION
Can be `public` or `private`. If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+,
visibility can also be `internal`. The visibility parameter overrides the private parameter.
DESCRIPTION
  default     = null
  nullable    = true
  validation {
    condition     = var.visibility == null || var.visibility == "public" || var.visibility == "private" || var.visibility == "internal"
    error_message = "The visibility variable must be either 'public', 'private', 'internal' or null."
  }
}

variable "has_issues" {
  type        = bool
  description = "Whether issues are enabled."
  default     = true
  nullable    = false
}

variable "has_discussions" {
  type        = bool
  description = "(Optional) Set to `true` to enable GitHub Discussions on the repository. Defaults to `false`."
  default     = false

}

variable "has_projects" {
  type        = bool
  description = <<DESCRIPTION
(Optional) Set to `true` to enable the GitHub Projects features on the repository.
Per the GitHub documentation when in an organization that has disabled repository projects it will default to `false` and will otherwise default to `true`.
If you specify `true` when it has been disabled it will return an error.
DESCRIPTION
  default     = true
}

variable "has_wiki" {
  type        = bool
  description = "Whether the wiki is enabled."
  default     = true
  nullable    = false
}

variable "is_template" {
  type        = bool
  description = "(Optional) Set to `true` to tell GitHub that this is a template repository."
  default     = false
}

variable "allow_merge_commit" {
  type        = bool
  description = "Whether to allow merge commits on pull requests."
  default     = true
  nullable    = false
}

variable "allow_squash_merge" {
  type        = bool
  description = "Whether to allow squash merges on pull requests."
  default     = true
  nullable    = false
}

variable "allow_rebase_merge" {
  type        = bool
  description = "Whether to allow rebase merges on pull requests."
  default     = true
  nullable    = false
}

variable "allow_auto_merge" {
  type        = bool
  description = "Whether to allow auto-merge on pull requests."
  default     = false
  nullable    = false
}

variable "squash_merge_commit_title" {
  type        = string
  description = <<DESCRIPTION
(Optional) Can be PR_TITLE or COMMIT_OR_PR_TITLE for a default squash merge commit title.
Applicable only if allow_squash_merge is true.
DESCRIPTION
  default     = null
  validation {
    condition     = var.squash_merge_commit_title == null || (var.squash_merge_commit_title == "PR_TITLE" && var.allow_squash_merge == true) || (var.squash_merge_commit_title == "COMMIT_OR_PR_TITLE" && var.allow_squash_merge == true)
    error_message = "The squash_merge_commit_title variable must be either 'PR_TITLE', 'COMMIT_OR_PR_TITLE' or null. If using 'PR_TITLE' or 'COMMIT_OR_PR_TITLE' then allow_squash_merge must be set to true."
  }
}

variable "squash_merge_commit_message" {
  type        = string
  description = <<DESCRIPTION
(Optional) Can be PR_BODY, COMMIT_MESSAGES, or BLANK for a default squash merge commit message.
Applicable only if allow_squash_merge is true.
DESCRIPTION
  default     = null
  validation {
    condition     = var.squash_merge_commit_message == null || (var.squash_merge_commit_message == "PR_BODY" && var.allow_squash_merge == true) || (var.squash_merge_commit_message == "COMMIT_MESSAGES" && var.allow_squash_merge == true) || (var.squash_merge_commit_message == "BLANK" && var.allow_squash_merge == true)
    error_message = "The squash_merge_commit_message variable must be either 'PR_BODY', 'COMMIT_MESSAGES', 'BLANK' or null. If using 'PR_BODY', 'COMMIT_MESSAGES' or 'BLANK' then allow_squash_merge must be set to true."
  }
}

variable "merge_commit_title" {
  type        = string
  description = <<DESCRIPTION
Can be PR_TITLE or MERGE_MESSAGE for a default merge commit title. Applicable only if allow_merge_commit is true.
DESCRIPTION
  default     = null
  validation {
    condition     = var.merge_commit_title == null || (var.merge_commit_title == "PR_TITLE" && var.allow_merge_commit == true) || (var.merge_commit_title == "MERGE_MESSAGE" && var.allow_merge_commit == true)
    error_message = "The merge_commit_title variable must be either 'PR_TITLE', 'MERGE_MESSAGE' or null. If using 'PR_TITLE' or 'MERGE_MESSAGE' then allow_merge_commit must be set to true."
  }
}

variable "merge_commit_message" {
  type        = string
  description = <<DESCRIPTION
Can be PR_BODY, PR_TITLE, or BLANK for a default merge commit message. Applicable only if allow_merge_commit is true.
DESCRIPTION
  default     = null
  validation {
    condition     = var.merge_commit_message == null || (var.merge_commit_message == "PR_BODY" && var.allow_merge_commit == true) || (var.merge_commit_message == "PR_TITLE" && var.allow_merge_commit == true) || (var.merge_commit_message == "BLANK" && var.allow_merge_commit == true)
    error_message = "The merge_commit_message variable must be either 'PR_BODY', 'PR_TITLE', 'BLANK' or null. If using 'PR_BODY', 'PR_TITLE' or 'BLANK' then allow_merge_commit must be set to true."
  }
}

variable "delete_branch_on_merge" {
  type        = bool
  description = "Whether to delete head branches when pull requests are merged."
  default     = false
  nullable    = false
}

variable "web_commit_signoff_required" {
  type        = bool
  description = "Whether to require contributors to sign off on web-based commits."
  default     = false
  nullable    = false
}
variable "auto_init" {
  type        = bool
  description = "Whether to create an initial commit with empty README."
  default     = false
  nullable    = false
}

variable "gitignore_template" {
  type        = string
  description = <<DESCRIPTION
The .gitignore template to apply. For a list of possible values, see the GitHub API documentation.
Use the name of the template without the extension.
For example, use `Haskell` for the `Haskell.gitignore` template.
DESCRIPTION
  default     = null
  nullable    = true
}

variable "license_template" {
  type        = string
  description = <<DESCRIPTION
The license template to apply. For a list of possible values, see the GitHub API documentation.
Use the name of the template without the extension.
For example, use `mit` for the `MIT.txt` template.
DESCRIPTION
  default     = null
  nullable    = true
}

variable "archived" {
  type        = bool
  description = <<DESCRIPTION
(Optional) Specifies if the repository should be archived. Defaults to false. **NOTE** Currently, the API does not support unarchiving.
DESCRIPTION
  default     = false
  nullable    = false
}

variable "archive_on_destroy" {
  type        = bool
  description = "(Optional) Set to true to archive the repository instead of deleting on destroy."
  default     = false
  nullable    = false
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
  description = <<DESCRIPTION
(Optional) The repository's GitHub Pages configuration. Set to `null` to disable GitHub Pages.
If omitted, GitHub Pages will not be configured.

`source` - (Optional) The source configuration for GitHub Pages.
  `branch` - (Required) The branch to use for GitHub Pages.
  `path` - (Optional) The path to use for GitHub Pages. Can be `/` for the root or `/docs` for the docs folder.
`build_type` - (Optional) The build type to use for GitHub Pages. Can be `legacy` or `source`. If you use legacy as build type you need to set the option source.
`cname` - (Optional) The custom domain name to use for GitHub Pages.
DESCRIPTION
  default     = null
  nullable    = true
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
  description = <<DESCRIPTION
(Optional) The repository's security and analysis settings.
`advanced_security` - (Optional) The advanced security settings for the repository.
  `status` - (Required) The status of advanced security. Can be `enabled` or `disabled`.
`secret_scanning` - (Optional) The secret scanning settings for the repository.
  `status` - (Required) The status of secret scanning. Can be `enabled` or `disabled`. If set to `enabled`, the repository's visibility must be `public` or `security_and_analysis[0].advanced_security[0].status` must also be set to `enabled`.
`secret_scanning_push_protection` - (Optional) The secret scanning push protection settings for the repository.
  `status` - (Required) The status of secret scanning push protection. Can be `enabled` or `disabled`. If set to `enabled`, the repository's visibility must be `public` or `security_and_analysis[0].advanced_security[0].status` must also be set to `enabled`.
DESCRIPTION
  default     = null
  nullable    = true
}

variable "template" {
  type = object({
    owner                = string
    repository           = string
    include_all_branches = optional(bool, false)
  })
  description = <<DESCRIPTION
(Optional) Use a template repository to create this resource.

`owner` - (Required) The owner of the template repository. The owner can be a user or an organization.
`repository` - (Required) The name of the template repository.
`include_all_branches` - (Optional) Whether to include all branches from the template repository. Defaults to `false`, which only includes the default branch.
DESCRIPTION
  default     = null
  nullable    = true
}

variable "vulnerability_alerts" {
  type        = bool
  description = "(Optional) Set to `true` to enable vulnerability alerts on the repository. Defaults to `false`."
  default     = false
  nullable    = false
}

variable "ignore_vulnerability_alerts_during_read" {
  type        = bool
  description = "(Optional) Set to `true` to not call the vulnerability alerts endpoint so the resource can also be used without admin permissions during read. Defaults to `false`."
  default     = false
  nullable    = false
}

variable "allow_update_branch" {
  type        = bool
  description = "(Optional) Set to true to always suggest updating pull request branches. Defaults to false."
  default     = false
  nullable    = false
}

variable "default_branch" {
  type = object({
    branch = string
    rename = optional(bool, false)
  })
  description = <<DESCRIPTION
This setting allows you to set the default branch. Set this to `null` to leave the default branch unchanged.

`branch` - (Required) The name of the branch to set as the default branch.
`rename` - (Optional) Whether to rename the default branch if it already exists. Defaults to `false`.
DESCRIPTION
  default     = null
  nullable    = true
}

variable "repository_rulesets" {
  type        = list(any)
  description = "(Optional) A list of rulesets to apply to the repository."
  default     = []
  nullable    = false
}

variable "files" {
  type = list(object({
    content = string
    file    = string

    autocreate_branch               = optional(bool, false)
    autocreate_branch_source_branch = optional(string, null)
    autocreate_branch_source_sha    = optional(string, null)
    branch                          = optional(string, null)
    commit_author                   = optional(string, null)
    commit_email                    = optional(string, null)
    commit_message                  = optional(string, null)
    overwrite_on_create             = optional(bool, true)
  }))
  description = "(Optional) A list of files to create or update in the repository."
  default     = []
  nullable    = false
}

variable "secrets" {
  type        = list(object({
    name            = string
    encrypted_value = optional(string, null)
    plaintext_value = optional(string, null)
    type            = optional(string, "actions")
    is_variable     = optional(bool, false)
  }))
  description = "(Optional) A list of secrets or variables to create in the repository."
  default     = []
  nullable    = false
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

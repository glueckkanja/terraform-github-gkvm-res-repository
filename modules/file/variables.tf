variable "repository" {
  type        = string
  description = "(Required) The name of the repository to create the file in."
  nullable    = false

  validation {
    condition     = (var.repository != "")
    error_message = "The repository name cannot be an empty string."
  }
}

variable "file" {
  type        = string
  description = "(Required) The file path of the file to manage."
  nullable    = false

  validation {
    condition     = (var.file != "")
    error_message = "The file path cannot be an empty string."
  }
}

variable "content" {
  type        = string
  description = "(Required) The content of the file."
  default     = ""
  nullable    = false
}

# variable "branch" {
#   type        = string
#   description = "(Optional) The branch to commit the file to. Default: the repository's default branch."
#   default     = null
#   nullable    = true
# }

variable "commit_author" {
  type = string
  description = <<DESCRIPTION
(Optional) Committer author name to use.

**NOTE:** GitHub app users may omit author and email information so GitHub can verify commits as the GitHub App.
This maybe useful when a branch protection rule requires signed commits.
DESCRIPTION
  default  = null
  nullable = true
}

variable "commit_email" {
  type = string
  description = <<DESCRIPTION
(Optional) Committer email to use.

**NOTE:** GitHub app users may omit author and email information so GitHub can verify commits as the GitHub App.
This maybe useful when a branch protection rule requires signed commits.
DESCRIPTION
  default  = null
  nullable = true
}

variable "commit_message" {
  type        = string
  description = "(Optional) The commit message."
  default     = null
  nullable    = true
}

variable "autocreate_branch" {
  type        = bool
  description = "(Optional) Whether to create the branch if it does not already exist. Default: false."
  default     = false
  nullable    = false
}

variable "autocreate_branch_source_branch" {
  type        = string
  description = "(Optional) The branch to base the new branch on when `autocreate_branch` is true. Default: the repository's default branch."
  default     = null
  nullable    = true
}

variable "autocreate_branch_source_sha" {
  type        = string
  description = "(Optional) The SHA to base the new branch on when `autocreate_branch` is true. If both `autocreate_branch_source_branch` and `autocreate_branch_source_sha` are provided, `autocreate_branch_source_sha` takes precedence."
  default     = null
  nullable    = true
}

variable "overwrite_on_create" {
  type        = bool
  description = "(Optional) Whether to overwrite the file if it already exists when creating it. Default: true."
  default     = true
  nullable    = false
}

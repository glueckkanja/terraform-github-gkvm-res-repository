# variable "branch" {
#   type        = string
#   description = "(Optional) The branch to commit the file to. Default: the repository's default branch."
#   default     = null
#   nullable    = true
# }

variable "file" {
  type        = string
  description = "(Required) The file path of the file to manage."
  nullable    = false

  validation {
    condition     = (var.file != "")
    error_message = "The file path cannot be an empty string."
  }
}

variable "repository" {
  type        = string
  description = "(Required) The name of the repository to create the file in."
  nullable    = false

  validation {
    condition     = (var.repository != "")
    error_message = "The repository name cannot be an empty string."
  }
}

variable "autocreate_branch" {
  type        = bool
  default     = false
  description = "(Optional) Whether to create the branch if it does not already exist. Default: false."
  nullable    = false
}

variable "autocreate_branch_source_branch" {
  type        = string
  default     = null
  description = "(Optional) The branch to base the new branch on when `autocreate_branch` is true. Default: the repository's default branch."
}

variable "autocreate_branch_source_sha" {
  type        = string
  default     = null
  description = "(Optional) The SHA to base the new branch on when `autocreate_branch` is true. If both `autocreate_branch_source_branch` and `autocreate_branch_source_sha` are provided, `autocreate_branch_source_sha` takes precedence."
}

variable "commit_author" {
  type        = string
  default     = null
  description = <<DESCRIPTION
(Optional) Committer author name to use.

**NOTE:** GitHub app users may omit author and email information so GitHub can verify commits as the GitHub App.
This maybe useful when a branch protection rule requires signed commits.
DESCRIPTION
}

variable "commit_email" {
  type        = string
  default     = null
  description = <<DESCRIPTION
(Optional) Committer email to use.

**NOTE:** GitHub app users may omit author and email information so GitHub can verify commits as the GitHub App.
This maybe useful when a branch protection rule requires signed commits.
DESCRIPTION
}

variable "commit_message" {
  type        = string
  default     = null
  description = "(Optional) The commit message."
}

variable "content" {
  type        = string
  default     = ""
  description = "(Required) The content of the file."
  nullable    = false
}

variable "overwrite_on_create" {
  type        = bool
  default     = true
  description = "(Optional) Whether to overwrite the file if it already exists when creating it. Default: true."
  nullable    = false
}

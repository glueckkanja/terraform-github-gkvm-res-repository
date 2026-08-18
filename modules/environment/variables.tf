variable "name" {
  type        = string
  description = "(Required) The name of the environment."
  nullable    = false

  validation {
    condition     = length(var.name) > 0
    error_message = "The environment name must not be empty."
  }
}

variable "repository" {
  type        = string
  description = "(Required) The name of the repository to create the environment in."
  nullable    = false

  validation {
    condition     = var.repository != ""
    error_message = "The repository name cannot be an empty string."
  }
}

variable "can_admins_bypass" {
  type        = bool
  default     = true
  description = "(Optional) Whether administrators can bypass the environment's protection rules. Defaults to `true`, matching GitHub's own default."
  nullable    = false
}

variable "deployment_branch_policy" {
  type = object({
    protected_branches     = bool
    custom_branch_policies = bool
  })
  default     = null
  description = <<DESCRIPTION
(Optional) Restricts which branches and tags may deploy to this environment. Set to `null` to allow all branches.

- `protected_branches` - (Required) Whether only branches with branch protection rules may deploy.
- `custom_branch_policies` - (Required) Whether only branches matching the patterns in `deployment_policies` may deploy.

Exactly one of the two may be `true`; GitHub rejects any other combination.
DESCRIPTION

  validation {
    condition     = var.deployment_branch_policy == null || (var.deployment_branch_policy.protected_branches != var.deployment_branch_policy.custom_branch_policies)
    error_message = "Exactly one of 'protected_branches' and 'custom_branch_policies' must be true."
  }
}

variable "deployment_policies" {
  type = list(object({
    branch_pattern = optional(string, null)
    tag_pattern    = optional(string, null)
  }))
  default     = []
  description = <<DESCRIPTION
(Optional) Branch and tag patterns allowed to deploy to this environment.

- `branch_pattern` - (Optional) A branch name pattern, for example `main` or `releases/*`.
- `tag_pattern` - (Optional) A tag name pattern, for example `v*`.

Each entry must set exactly one of the two. Entries require `deployment_branch_policy.custom_branch_policies` to be `true`.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for p in var.deployment_policies : (p.branch_pattern == null) != (p.tag_pattern == null)])
    error_message = "Each deployment policy must set exactly one of 'branch_pattern' or 'tag_pattern'."
  }

  validation {
    condition = length(distinct([
      for p in var.deployment_policies :
      format("%s-%s", p.branch_pattern == null ? "tag" : "branch", coalesce(p.branch_pattern, p.tag_pattern))
    ])) == length(var.deployment_policies)
    error_message = "Each deployment policy pattern must be unique within its kind."
  }
}

variable "prevent_self_review" {
  type        = bool
  default     = false
  description = "(Optional) Whether the user who triggered the deployment is prevented from approving it. Defaults to `false`."
  nullable    = false
}

variable "reviewers" {
  type = object({
    teams = optional(set(number), null)
    users = optional(set(number), null)
  })
  default     = null
  description = <<DESCRIPTION
(Optional) Users and teams that must approve deployments to this environment.

- `teams` - (Optional) Team IDs that may review. Note that this is the team's numeric ID, not its slug.
- `users` - (Optional) User IDs that may review.

GitHub allows at most six reviewers in total.
DESCRIPTION

  validation {
    condition     = var.reviewers == null || length(coalesce(var.reviewers.teams, [])) + length(coalesce(var.reviewers.users, [])) <= 6
    error_message = "An environment supports at most 6 reviewers in total across 'teams' and 'users'."
  }

  validation {
    condition     = var.reviewers == null || length(coalesce(var.reviewers.teams, [])) + length(coalesce(var.reviewers.users, [])) > 0
    error_message = "When 'reviewers' is set, at least one team or user must be given. Use null to disable required reviewers."
  }
}

variable "secrets" {
  type = list(object({
    name            = string
    value           = optional(string, null)
    value_encrypted = optional(string, null)
    key_id          = optional(string, null)
  }))
  default     = []
  description = <<DESCRIPTION
(Optional) Actions secrets scoped to this environment.

- `name` - (Required) The name of the secret.
- `value` - (Optional) The plaintext value. The provider encrypts it before sending it to GitHub.
- `value_encrypted` - (Optional) A value already encrypted with the repository public key, in Base64.
- `key_id` - (Optional) The ID of the public key used for `value_encrypted`. Required when `value_encrypted` is set.

Each entry must set exactly one of `value` and `value_encrypted`.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for s in var.secrets : (s.value == null) != (s.value_encrypted == null)])
    error_message = "Each secret must set exactly one of 'value' or 'value_encrypted'."
  }

  validation {
    condition     = alltrue([for s in var.secrets : s.value_encrypted == null || s.key_id != null])
    error_message = "'key_id' is required whenever 'value_encrypted' is set."
  }

  validation {
    condition     = length(distinct([for s in var.secrets : s.name])) == length(var.secrets)
    error_message = "Each secret name must be unique within an environment."
  }
}

variable "variables" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = <<DESCRIPTION
(Optional) Actions variables scoped to this environment.

- `name` - (Required) The name of the variable.
- `value` - (Required) The value of the variable.
DESCRIPTION
  nullable    = false

  validation {
    condition     = length(distinct([for v in var.variables : v.name])) == length(var.variables)
    error_message = "Each variable name must be unique within an environment."
  }
}

variable "wait_timer" {
  type        = number
  default     = null
  description = "(Optional) The time to wait, in minutes, before allowing deployments to proceed. Between 0 and 43200 (30 days)."

  validation {
    condition     = var.wait_timer == null || try(var.wait_timer >= 0 && var.wait_timer <= 43200, false)
    error_message = "The 'wait_timer' must be between 0 and 43200 minutes."
  }
}

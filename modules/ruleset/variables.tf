variable "enforcement" {
  type        = string
  description = <<DESCRIPTION
Possible values for Enforcement are `disabled`, `active`, `evaluate`. Note: `evaluate` is currently only supported for owners of type organization."
DESCRIPTION
  nullable    = false

  validation {
    condition     = var.enforcement == "disabled" || var.enforcement == "active" || var.enforcement == "evaluate"
    error_message = "Enforcement must be one of 'disabled', 'active', or 'evaluate'."
  }
}

variable "name" {
  type        = string
  description = "The name of the ruleset."
  nullable    = false

  validation {
    condition     = length(var.name) > 0
    error_message = "Name must not be empty."
  }
}

variable "rules" {
  type = object({
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
      required_last_push_approval       = optional(bool, false)
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
  })
  description = <<DESCRIPTION
Rules within the ruleset. This object supports the following attributes:

## Boolean Attributes

- `creation` - (Optional) Only allow users with bypass permission to create matching refs. Defaults to `false`.
- `update` - (Optional) Only allow users with bypass permission to update matching refs. Defaults to `false`.
- `deletion` - (Optional) Only allow users with bypass permissions to delete matching refs. Defaults to `false`.
- `non_fast_forward` - (Optional) Prevent users with push access from force pushing to branches. Defaults to `false`.
- `required_linear_history` - (Optional) Prevent merge commits from being pushed to matching branches. Defaults to `false`.
- `required_signatures` - (Optional) Commits pushed to matching branches must have verified signatures. Defaults to `false`.
- `update` - (Optional) Only allow users with bypass permission to update matching refs. Defaults to `false`.
- `update_allows_fetch_and_merge` - (Optional) Branch can pull changes from its upstream repository. This is only applicable to forked repositories. Requires `update` to be set to `true`. Defaults to `false`.

## Pattern Matching Rules

### `branch_name_pattern`

Parameters to be used for the branch_name_pattern rule. This rule only applies to repositories within an enterprise, it cannot be applied to repositories owned by individuals or regular organizations. Conflicts with `tag_name_pattern` as it only applies to rulesets with target `branch`.

- `operator` - (Required) The operator to use for matching. Can be one of: `starts_with`, `ends_with`, `contains`, `regex`.
- `pattern` - (Required) The pattern to match with.
- `name` - (Optional) How this rule will appear to users.
- `negate` - (Optional) If true, the rule will fail if the pattern matches. Defaults to `false`.

### `commit_author_email_pattern`

Parameters to be used for the commit_author_email_pattern rule. This rule only applies to repositories within an enterprise, it cannot be applied to repositories owned by individuals or regular organizations.

- `operator` - (Required) The operator to use for matching. Can be one of: `starts_with`, `ends_with`, `contains`, `regex`.
- `pattern` - (Required) The pattern to match with.
- `name` - (Optional) How this rule will appear to users.
- `negate` - (Optional) If true, the rule will fail if the pattern matches. Defaults to `false`.

### `commit_message_pattern`

Parameters to be used for the commit_message_pattern rule. This rule only applies to repositories within an enterprise, it cannot be applied to repositories owned by individuals or regular organizations.

- `operator` - (Required) The operator to use for matching. Can be one of: `starts_with`, `ends_with`, `contains`, `regex`.
- `pattern` - (Required) The pattern to match with.
- `name` - (Optional) How this rule will appear to users.
- `negate` - (Optional) If true, the rule will fail if the pattern matches. Defaults to `false`.

### `committer_email_pattern`

Parameters to be used for the committer_email_pattern rule. This rule only applies to repositories within an enterprise, it cannot be applied to repositories owned by individuals or regular organizations.

- `operator` - (Required) The operator to use for matching. Can be one of: `starts_with`, `ends_with`, `contains`, `regex`.
- `pattern` - (Required) The pattern to match with.
- `name` - (Optional) How this rule will appear to users.
- `negate` - (Optional) If true, the rule will fail if the pattern matches. Defaults to `false`.

### `tag_name_pattern`

Parameters to be used for the tag_name_pattern rule. This rule only applies to repositories within an enterprise, it cannot be applied to repositories owned by individuals or regular organizations. Conflicts with `branch_name_pattern` as it only applies to rulesets with target `tag`.

- `operator` - (Required) The operator to use for matching. Can be one of: `starts_with`, `ends_with`, `contains`, `regex`.
- `pattern` - (Required) The pattern to match with.
- `name` - (Optional) How this rule will appear to users.
- `negate` - (Optional) If true, the rule will fail if the pattern matches. Defaults to `false`.

## Complex Rules

### `merge_queue`

Merges must be performed via a merge queue.

- `check_response_timeout_minutes` - (Optional) Maximum time (in minutes) for a required status check to report a conclusion. After this much time has elapsed, checks that have not reported a conclusion will be assumed to have failed. Defaults to `60`.
- `grouping_strategy` - (Optional) When set to `ALLGREEN`, the merge commit created by merge queue for each PR in the group must pass all required checks to merge. When set to `HEADGREEN`, only the commit at the head of the merge group, i.e. the commit containing changes from all of the PRs in the group, must pass its required checks to merge. Can be one of: `ALLGREEN`, `HEADGREEN`. Defaults to `ALLGREEN`.
- `max_entries_to_build` - (Optional) Limit the number of queued pull requests requesting checks and workflow runs at the same time. Defaults to `5`.
- `max_entries_to_merge` - (Optional) The maximum number of PRs that will be merged together in a group. Defaults to `5`.
- `merge_method` - (Optional) Method to use when merging changes from queued pull requests. Can be one of: `MERGE`, `SQUASH`, `REBASE`. Defaults to `MERGE`.
- `min_entries_to_merge` - (Optional) The minimum number of PRs that will be merged together in a group. Defaults to `1`.
- `min_entries_to_merge_wait_minutes` - (Optional) The time merge queue should wait after the first PR is added to the queue for the minimum group size to be met. After this time has elapsed, the minimum group size will be ignored and a smaller group will be merged. Defaults to `5`.

### `pull_request`

Require all commits be made to a non-target branch and submitted via a pull request before they can be merged.

- `dismiss_stale_reviews_on_push` - (Optional) New, reviewable commits pushed will dismiss previous pull request review approvals. Defaults to `false`.
- `require_code_owner_review` - (Optional) Require an approving review in pull requests that modify files that have a designated code owner. Defaults to `false`.
- `required_last_push_approval` - (Optional) Whether the most recent reviewable push must be approved by someone other than the person who pushed it. Defaults to `false`.
- `required_approving_review_count` - (Optional) The number of approving reviews that are required before a pull request can be merged. Defaults to `0`.
- `required_review_thread_resolution` - (Optional) All conversations on code must be resolved before a pull request can be merged. Defaults to `false`.

### `required_deployments`

Choose which environments must be successfully deployed to before branches can be merged into a branch that matches this rule.

- `required_deployment_environments` - (Required) The environments that must be successfully deployed to before branches can be merged. This is a list of strings.

### `required_status_checks`

Choose which status checks must pass before branches can be merged into a branch that matches this rule. When enabled, commits must first be pushed to another branch, then merged or pushed directly to a branch that matches this rule after status checks have passed.

- `required_check` - (Required) Status checks that are required. List of objects with the following attributes:
  - `context` - (Required) The status check context name that must be present on the commit.
  - `integration_id` - (Optional) The optional integration ID that this status check must originate from.
- `strict_required_status_checks_policy` - (Optional) Whether pull requests targeting a matching branch must be tested with the latest code. This setting will not take effect unless at least one status check is enabled. Defaults to `false`.
- `do_not_enforce_on_create` - (Optional) Allow repositories and branches to be created if a check would otherwise prohibit it. Defaults to `false`.

### `required_code_scanning`

Choose which tools must provide code scanning results before the reference is updated. When configured, code scanning must be enabled and have results for both the commit and the reference being updated.

- `required_code_scanning_tool` - (Required) Tools that must provide code scanning results for this rule to pass. List of objects with the following attributes:
  - `alerts_threshold` - (Required) The severity level at which code scanning results that raise alerts block a reference update. Can be one of: `none`, `errors`, `errors_and_warnings`, `all`.
  - `security_alerts_threshold` - (Required) The severity level at which code scanning results that raise security alerts block a reference update. Can be one of: `none`, `critical`, `high_or_higher`, `medium_or_higher`, `all`.
  - `tool` - (Required) The name of a code scanning tool.

DESCRIPTION
  default     = {}
  nullable    = false
}

variable "target" {
  type        = string
  description = <<DESCRIPTION
The type of ref that the ruleset applies to. Can be one of: `branch`, `tag`.
DESCRIPTION
  nullable    = false

  validation {
    condition     = var.target == "branch" || var.target == "tag"
    error_message = "Target must be one of 'branch' or 'tag'."
  }
}

variable "bypass_actors" {
  type = list(object({
    actor_id    = number
    actor_type  = string
    bypass_mode = string
  }))
  description = <<DESCRIPTION
Actors that can bypass the ruleset. This object supports the following attributes:

- `actor_id` - (Required) The ID of the actor that can bypass the ruleset. For a user, this is their user ID. For a team, this is the team's node ID. For an app, this is the app's ID.
- `actor_type` - (Required) The type of actor that can bypass the ruleset. Can be one of: `RepositoryRole`, `Team`, `Integration` and `OrganizationAdministrator`.
- `bypass_mode` - (Required) The mode in which the actor can bypass the ruleset. Can be one of: `always`, `pull_request`.
DESCRIPTION
  default     = []
  nullable    = false
}

variable "conditions" {
  type = object({
    ref_name = object({
      include = list(string)
      exclude = list(string)
    })
  })
  description = <<DESCRIPTION
Conditions that must be met for the ruleset to apply. This object supports the following attributes:

- `ref_name` - (Required) The name of the reference (branch or tag) to which the ruleset applies. This object supports the following attributes:
  - `include` - (Required) A list of reference names that must be included.
  - `exclude` - (Required) A list of reference names that must be excluded.
DESCRIPTION
  default     = null
  nullable    = true
}

variable "repository" {
  type        = string
  description = "The name of the repository to which the ruleset will be applied."
  default     = null
  nullable    = true
}

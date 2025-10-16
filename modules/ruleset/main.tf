resource "github_repository_ruleset" "this" {
  enforcement = var.enforcement
  name        = var.name

  target     = var.target
  repository = var.repository

  dynamic "bypass_actors" {
    for_each = var.bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  dynamic "conditions" {
    for_each = var.conditions == null ? [] : [1]
    content {

      dynamic "ref_name" {
        content {
          exclude = var.conditions.ref_name.exclude
          include = var.conditions.ref_name.include
        }
      }

    }
  }

  dynamic "rules" {
    content {
      creation                      = var.rules.creation
      update                        = var.rules.update
      update_allows_fetch_and_merge = var.rules.update_allows_fetch_and_merge
      deletion                      = var.rules.deletion
      non_fast_forward              = var.rules.non_fast_forward
      required_linear_history       = var.rules.required_linear_history
      required_signatures           = var.rules.required_signatures

      dynamic "branch_name_pattern" {
        for_each = var.rules.branch_name_pattern == null ? [] : [1]
        content {
          operator = var.rules.branch_name_pattern.operator
          pattern  = var.rules.branch_name_pattern.pattern
          name     = var.rules.branch_name_pattern.name
          negate   = var.rules.branch_name_pattern.negate
        }
      }

      dynamic "commit_author_email_pattern" {
        for_each = var.rules.commit_author_email_pattern == null ? [] : [1]
        content {
          operator = var.rules.commit_author_email_pattern.operator
          pattern  = var.rules.commit_author_email_pattern.pattern
          name     = var.rules.commit_author_email_pattern.name
          negate   = var.rules.commit_author_email_pattern.negate
        }
      }

      dynamic "commit_message_pattern" {
        for_each = var.rules.commit_message_pattern == null ? [] : [1]
        content {
          operator = var.rules.commit_message_pattern.operator
          pattern  = var.rules.commit_message_pattern.pattern
          name     = var.rules.commit_message_pattern.name
          negate   = var.rules.commit_message_pattern.negate
        }
      }

      dynamic "committer_email_pattern" {
        for_each = var.rules.committer_email_pattern == null ? [] : [1]
        content {
          operator = var.rules.committer_email_pattern.operator
          pattern  = var.rules.committer_email_pattern.pattern
          name     = var.rules.committer_email_pattern.name
          negate   = var.rules.committer_email_pattern.negate
        }
      }

      dynamic "merge_queue" {
        for_each = var.rules.merge_queue == null ? [] : [1]
        content {
          check_response_timeout_seconds    = var.rules.merge_queue.check_response_timeout_seconds
          grouping_strategy                 = var.rules.merge_queue.grouping_strategy
          max_entries_to_build              = var.rules.merge_queue.max_entries_to_build
          max_entries_to_merge              = var.rules.merge_queue.max_entries_to_merge
          merge_method                      = var.rules.merge_queue.merge_method
          min_entries_to_merge              = var.rules.merge_queue.min_entries_to_merge
          min_entries_to_merge_wait_minutes = var.rules.merge_queue.min_entries_to_merge_wait_minutes
        }
      }

      dynamic "pull_request" {
        for_each = var.rules.pull_request == null ? [] : [1]
        content {
          dismiss_stale_reviews_on_push     = var.rules.pull_request.dismiss_stale_reviews_on_push
          require_code_owner_review         = var.rules.pull_request.require_code_owner_review
          required_last_push_approval       = var.rules.pull_request.required_last_push_approval
          required_approving_review_count   = var.rules.pull_request.required_approving_review_count
          required_review_thread_resolution = var.rules.pull_request.required_review_thread_resolution
        }
      }

      dynamic "required_deployments" {
        for_each = var.rules.required_deployments == null ? [] : [1]
        content {
          required_deployment_environments = var.rules.required_deployments.required_deployment_environments
        }
      }

      dynamic "required_status_checks" {
        for_each = var.rules.required_status_checks == null ? [] : [1]
        content {

          dynamic "required_check" {
            for_each = var.rules.required_status_checks.required_checks
            content {
              context = required_check.value.context
              app_id  = required_check.value.app_id
            }
          }

          strict_required_status_checks_policy = var.rules.required_status_checks.strict_required_status_checks_policy
          do_not_enforce_on_create             = var.rules.required_status_checks.do_not_enforce_on_create
        }
      }

      dynamic "tag_name_pattern" {
        for_each = var.rules.tag_name_pattern == null ? [] : [1]
        content {
          operator = var.rules.tag_name_pattern.operator
          pattern  = var.rules.tag_name_pattern.pattern
          name     = var.rules.tag_name_pattern.name
          negate   = var.rules.tag_name_pattern.negate
        }
      }

      dynamic "required_code_scanning" {
        for_each = var.rules.required_code_scanning == null ? [] : [1]
        content {

          dynamic "required_code_scanning_tool" {
            for_each = var.rules.required_code_scanning.required_code_scanning_tools
            content {
              alerts_threshold          = required_code_scanning_tool.value.alerts_threshold
              security_alerts_threshold = required_code_scanning_tool.value.security_alerts_threshold
              tool                      = required_code_scanning_tool.value.tool
            }
          }
        }
      }
    }
  }
}

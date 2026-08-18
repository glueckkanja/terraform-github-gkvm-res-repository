resource "github_repository_environment" "this" {
  environment = var.name
  repository  = var.repository

  can_admins_bypass   = var.can_admins_bypass
  prevent_self_review = var.prevent_self_review
  wait_timer          = var.wait_timer

  dynamic "deployment_branch_policy" {
    for_each = var.deployment_branch_policy == null ? [] : [1]
    content {
      protected_branches     = var.deployment_branch_policy.protected_branches
      custom_branch_policies = var.deployment_branch_policy.custom_branch_policies
    }
  }

  dynamic "reviewers" {
    for_each = var.reviewers == null ? [] : [1]
    content {
      teams = var.reviewers.teams
      users = var.reviewers.users
    }
  }
}

# Keyed by pattern kind and pattern, so that reordering the list does not
# rewrite state. See AGENTS.md on for_each keys being state addresses.
resource "github_repository_environment_deployment_policy" "this" {
  for_each = {
    for p in var.deployment_policies :
    format("%s-%s", p.branch_pattern == null ? "tag" : "branch", coalesce(p.branch_pattern, p.tag_pattern)) => p
  }

  environment = github_repository_environment.this.environment
  repository  = var.repository

  branch_pattern = each.value.branch_pattern
  tag_pattern    = each.value.tag_pattern
}

resource "github_actions_environment_secret" "this" {
  for_each = { for s in var.secrets : s.name => s }

  environment = github_repository_environment.this.environment
  repository  = var.repository
  secret_name = each.value.name

  key_id          = each.value.key_id
  value           = each.value.value
  value_encrypted = each.value.value_encrypted
}

resource "github_actions_environment_variable" "this" {
  for_each = { for v in var.variables : v.name => v }

  environment   = github_repository_environment.this.environment
  repository    = var.repository
  variable_name = each.value.name
  value         = each.value.value
}

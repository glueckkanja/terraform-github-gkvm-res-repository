resource "github_repository" "this" {
  for_each = local.github_repository

  name                        = each.value.name
  allow_auto_merge            = each.value.allow_auto_merge
  allow_merge_commit          = each.value.allow_merge_commit
  allow_rebase_merge          = each.value.allow_rebase_merge
  allow_squash_merge          = each.value.allow_squash_merge
  allow_update_branch         = each.value.allow_update_branch
  archive_on_destroy          = each.value.archive_on_destroy
  archived                    = each.value.archived
  auto_init                   = each.value.auto_init
  gitignore_template          = each.value.gitignore_template
  has_discussions             = each.value.has_discussions
  has_downloads               = each.value.has_downloads
  has_issues                  = each.value.has_issues
  has_projects                = each.value.has_projects
  has_wiki                    = each.value.has_wiki
  homepage_url                = each.value.homepage_url
  is_template                 = each.value.is_template
  merge_commit_message        = each.value.merge_commit_message
  merge_commit_title          = each.value.merge_commit_title
  squash_merge_commit_message = each.value.squash_merge_commit_message
  squash_merge_commit_title   = each.value.squash_merge_commit_title
  topics                      = each.value.topics
  visibility                  = each.value.visibility

  dynamic "template" {
    for_each = each.value.template
    content {
      owner                = template.value.owner
      repository           = template.value.repository
      include_all_branches = template.value.include_all_branches
    }
  }

  depends_on = [
    data.github_user.onboarding
  ]

  lifecycle {
    # Added to ignore changes to the template block to avoid by any means that something goes wrong :-)
    ignore_changes = [
      template,
      vulnerability_alerts,
      topics,
    ]
  }

}

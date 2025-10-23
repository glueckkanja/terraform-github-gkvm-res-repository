resource "github_repository" "this" {
  name = var.name

  allow_auto_merge                        = var.allow_auto_merge
  allow_merge_commit                      = var.allow_merge_commit
  allow_rebase_merge                      = var.allow_rebase_merge
  allow_squash_merge                      = var.allow_squash_merge
  allow_update_branch                     = var.allow_update_branch
  archive_on_destroy                      = var.archive_on_destroy
  archived                                = var.archived
  auto_init                               = var.auto_init
  delete_branch_on_merge                  = var.delete_branch_on_merge
  description                             = var.description
  gitignore_template                      = var.gitignore_template
  has_discussions                         = var.has_discussions
  has_issues                              = var.has_issues
  has_projects                            = var.has_projects
  has_wiki                                = var.has_wiki
  homepage_url                            = var.homepage_url
  ignore_vulnerability_alerts_during_read = var.ignore_vulnerability_alerts_during_read
  is_template                             = var.is_template
  license_template                        = var.license_template
  merge_commit_message                    = var.merge_commit_message
  merge_commit_title                      = var.merge_commit_title
  squash_merge_commit_message             = var.squash_merge_commit_message
  squash_merge_commit_title               = var.squash_merge_commit_title
  visibility                              = var.visibility
  vulnerability_alerts                    = var.vulnerability_alerts
  web_commit_signoff_required             = var.web_commit_signoff_required

  dynamic "pages" {
    for_each = var.pages == null ? [] : [1]
    content {

      build_type = var.pages.build_type == null ? null : var.pages.build_type
      cname      = var.pages.cname == null ? null : var.pages.cname

      dynamic "source" {
        for_each = var.pages.source == null ? [] : [1]
        content {
          branch = var.pages.source.branch
          path   = var.pages.source.path == null ? null : var.pages.source.path
        }
      }

    }
  }

  dynamic "security_and_analysis" {
    for_each = var.security_and_analysis == null ? [] : [1]
    content {

      dynamic "advanced_security" {
        for_each = var.security_and_analysis.advanced_security == null ? [] : [1]
        content {
          status = var.security_and_analysis.advanced_security.status
        }
      }

      dynamic "secret_scanning" {
        for_each = var.security_and_analysis.secret_scanning == null ? [] : [1]
        content {
          status = var.security_and_analysis.secret_scanning.status
        }
      }

      dynamic "secret_scanning_push_protection" {
        for_each = var.security_and_analysis.secret_scanning_push_protection == null ? [] : [1]
        content {
          status = var.security_and_analysis.secret_scanning_push_protection.status
        }
      }
    }
  }

  dynamic "template" {
    for_each = var.template == null ? [] : [1]
    content {
      owner                = var.template.owner
      repository           = var.template.repository
      include_all_branches = var.template.include_all_branches
    }
  }

  lifecycle {
    ignore_changes = [
      template,
    ]
  }
}

resource "github_branch_default" "this" {
  count = var.default_branch == null ? 0 : 1

  repository = var.name
  branch     = var.default_branch.branch
  rename     = var.default_branch.rename
}

module "rulesets" {
  source   = "./modules/ruleset"
  for_each = { for idx, val in var.repository_rulesets : val.name => val }

  enforcement   = each.value.enforcement
  name          = each.value.name
  target        = each.value.target
  bypass_actors = each.value.bypass_actors
  conditions    = each.value.conditions
  repository    = github_repository.this.name
  rules         = each.value.rules

  depends_on = [
    github_repository.this
  ]
}

module "files" {
  source   = "./modules/file"
  for_each = { for idx, val in var.files : val.file => val }

  file                            = each.value.file
  repository                      = github_repository.this.name
  autocreate_branch               = each.value.autocreate_branch
  autocreate_branch_source_branch = each.value.autocreate_branch_source_branch
  autocreate_branch_source_sha    = each.value.autocreate_branch_source_sha
  # branch                          = each.value.branch
  commit_author  = each.value.commit_author
  commit_email   = each.value.commit_email
  commit_message = each.value.commit_message
  content        = each.value.content

  depends_on = [
    github_repository.this
  ]
}

module "secrets" {
  source   = "./modules/secrets"
  for_each = { for idx, val in var.secrets : format("%s-%s", lower(val.type), lower(val.name)) => val }

  encrypted_value = each.value.encrypted_value
  name            = each.value.name
  plaintext_value = each.value.plaintext_value
  repository      = github_repository.this.name
  is_variable     = each.value.is_variable
  type            = each.value.type

  depends_on = [
    github_repository.this
  ]
}


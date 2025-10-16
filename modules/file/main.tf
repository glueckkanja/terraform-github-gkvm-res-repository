resource "github_repository_file" "this" {
  content    = var.content
  file       = var.file
  repository = var.repository

  autocreate_branch               = var.autocreate_branch
  autocreate_branch_source_branch = var.autocreate_branch_source_branch
  autocreate_branch_source_sha    = var.autocreate_branch_source_sha
  branch                          = var.branch
  commit_author                   = var.commit_author
  commit_email                    = var.commit_email
  commit_message                  = var.commit_message
}

output "resource" {
  description = "The full `github_repository` resource object."
  value       = github_repository.this
}

output "resource_id" {
  description = "The ID (name) of the repository."
  value       = github_repository.this.id
}

output "name" {
  description = "The name of the repository."
  value       = github_repository.this.name
}

output "full_name" {
  description = "The full name of the repository, in the form `owner/name`."
  value       = github_repository.this.full_name
}

output "node_id" {
  description = "The GraphQL global node ID of the repository, for use with the v4 API."
  value       = github_repository.this.node_id
}

output "repo_id" {
  description = "The numeric GitHub ID of the repository."
  value       = github_repository.this.repo_id
}

output "html_url" {
  description = "The URL of the repository on GitHub."
  value       = github_repository.this.html_url
}

output "http_clone_url" {
  description = "The HTTPS clone URL of the repository."
  value       = github_repository.this.http_clone_url
}

output "ssh_clone_url" {
  description = "The SSH clone URL of the repository."
  value       = github_repository.this.ssh_clone_url
}

output "git_clone_url" {
  description = "The Git protocol clone URL of the repository."
  value       = github_repository.this.git_clone_url
}

output "default_branch" {
  description = "The name of the default branch of the repository, or `null` when the default branch is not managed by this module."
  value       = one(github_branch_default.this[*].branch)
}

output "visibility" {
  description = "The visibility of the repository."
  value       = github_repository.this.visibility
}

output "rulesets" {
  description = "A map of the created rulesets, keyed by ruleset name."
  value       = { for k, v in module.rulesets : k => v.resource }
}

output "files" {
  description = "A map of the created repository files, keyed by file path."
  value       = { for k, v in module.files : k => v.resource }
}

output "secrets" {
  description = <<DESCRIPTION
A map of the created secrets and variables, keyed by `<type>-<secret|variable>-<name>`.
Only metadata is exported; secret values are never returned.
DESCRIPTION
  value = { for k, v in module.secrets : k => {
    resource_id = v.resource_id
    name        = v.name
    type        = v.type
    is_variable = v.is_variable
    created_at  = v.created_at
    updated_at  = v.updated_at
  } }
}

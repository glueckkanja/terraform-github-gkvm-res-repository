output "resource" {
  description = "The full `github_repository_ruleset` resource object."
  value       = github_repository_ruleset.this
}

output "resource_id" {
  description = "The ID of the repository ruleset."
  value       = github_repository_ruleset.this.id
}

output "name" {
  description = "The name of the repository ruleset."
  value       = github_repository_ruleset.this.name
}

output "node_id" {
  description = "The GraphQL global node ID of the repository ruleset."
  value       = github_repository_ruleset.this.node_id
}

output "ruleset_id" {
  description = "The GitHub ID of the repository ruleset."
  value       = github_repository_ruleset.this.ruleset_id
}

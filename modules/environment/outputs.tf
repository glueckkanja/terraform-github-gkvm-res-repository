# NOTE: the secret resources are deliberately not exported, because
# `github_actions_environment_secret` carries the `value` attribute.

output "resource" {
  description = "The full `github_repository_environment` resource object."
  value       = github_repository_environment.this
}

output "resource_id" {
  description = "The ID of the environment."
  value       = github_repository_environment.this.id
}

output "name" {
  description = "The name of the environment."
  value       = github_repository_environment.this.environment
}

output "repository_id" {
  description = "The numeric GitHub ID of the repository the environment belongs to."
  value       = github_repository_environment.this.repository_id
}

output "deployment_policies" {
  description = "A map of the created deployment branch and tag policies, keyed by `<branch|tag>-<pattern>`."
  value       = github_repository_environment_deployment_policy.this
}

output "secrets" {
  description = <<DESCRIPTION
A map of the environment secrets, keyed by secret name. Metadata only; secret values are never returned.
DESCRIPTION
  value = { for k, v in github_actions_environment_secret.this : k => {
    resource_id = v.id
    name        = v.secret_name
    created_at  = v.created_at
    updated_at  = v.updated_at
  } }
}

output "variables" {
  description = "A map of the created environment variables, keyed by variable name."
  value       = github_actions_environment_variable.this
}

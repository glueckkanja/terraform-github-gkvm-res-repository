# NOTE: the full resource objects are deliberately not exported, because
# `github_actions_secret`, `github_codespaces_secret` and `github_dependabot_secret`
# carry the `plaintext_value` attribute.

output "resource_id" {
  description = "The ID of the created secret or variable."
  value = one(concat(
    github_actions_secret.this[*].id,
    github_codespaces_secret.this[*].id,
    github_dependabot_secret.this[*].id,
    github_actions_variable.this[*].id,
  ))
}

output "name" {
  description = "The name of the created secret or variable."
  value       = var.name
}

output "type" {
  description = "The type of the created secret or variable."
  value       = var.type
}

output "is_variable" {
  description = "Whether an Actions variable was created instead of a secret."
  value       = var.is_variable
}

output "created_at" {
  description = "The date of the secret or variable creation."
  value = one(concat(
    github_actions_secret.this[*].created_at,
    github_codespaces_secret.this[*].created_at,
    github_dependabot_secret.this[*].created_at,
    github_actions_variable.this[*].created_at,
  ))
}

output "updated_at" {
  description = "The date of the secret or variable update."
  value = one(concat(
    github_actions_secret.this[*].updated_at,
    github_codespaces_secret.this[*].updated_at,
    github_dependabot_secret.this[*].updated_at,
    github_actions_variable.this[*].updated_at,
  ))
}

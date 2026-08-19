output "resource" {
  description = "The full `github_repository_custom_property` resource object."
  value       = github_repository_custom_property.this
}

output "resource_id" {
  description = "The ID of the repository custom property."
  value       = github_repository_custom_property.this.id
}

output "name" {
  description = "The name of the custom property."
  value       = github_repository_custom_property.this.property_name
}

output "type" {
  description = "The type of the custom property."
  value       = github_repository_custom_property.this.property_type
}

output "value" {
  description = "The value of the custom property, as a set of strings."
  value       = github_repository_custom_property.this.property_value
}

output "repository_id" {
  description = "The numeric GitHub ID of the repository the custom property is set on."
  value       = github_repository_custom_property.this.repository_id
}

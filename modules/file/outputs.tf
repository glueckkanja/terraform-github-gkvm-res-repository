output "resource" {
  description = "The full `github_repository_file` resource object."
  value       = github_repository_file.this
}

output "resource_id" {
  description = "The ID of the repository file."
  value       = github_repository_file.this.id
}

output "file" {
  description = "The path of the managed file within the repository."
  value       = github_repository_file.this.file
}

output "commit_sha" {
  description = "The SHA of the commit that modified the file."
  value       = github_repository_file.this.commit_sha
}

output "ref" {
  description = "The name of the branch the file is committed to."
  value       = github_repository_file.this.ref
}

output "sha" {
  description = "The blob SHA of the file."
  value       = github_repository_file.this.sha
}

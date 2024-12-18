output "description" {
  description = "Description of the repository."
  value       = github_repository.this.description
}

output "full_name" {
  description = "Full name of the repository, including organization. `org_name/repo_name`"
  value       = github_repository.this.full_name
}

output "is_template" {
  description = "Set to `true` if the repository is a template repository"
  value       = github_repository.this.is_template
}

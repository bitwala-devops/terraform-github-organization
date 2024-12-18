output "repo_env_name" {
  description = "Name of the repository environment."
  value       = var.name
}

output "secrets_names" {
  description = "List with the names of the secrets created in the environment."
  value       = { for name, value in github_actions_environment_secret.this : value.secret_name => value.plaintext_value }
}

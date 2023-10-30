output "hostname" {
  description = "The fully qualified DNS name of the GitHub instance which hosts this organization."
  value       = var.hostname
}

output "name" {
  description = "The name of this GitHub organization."
  value       = var.name
}

output "token" {
  description = "The OAuth / Personal Access Token used to manage the organization and its repositories' settings, such as webhooks."
  value       = local.token
  sensitive   = true
}

output "repositories" {
  description = <<-EOT
  A map of objects describing the managed GitHub repositories in this
  organization. The map key is the name of the repository, without the owner
  and the object attributes are:

  * description - A description of the repository.
  * full_name - A string of the form "orgname/reponame".
  * is_template - Set to `true` if the repository is a template repository.
  EOT

  value = tomap({ for name in keys(module.github_repository) : name => {
    description = module.github_repository[name].description
    full_name   = module.github_repository[name].full_name
    is_template = module.github_repository[name].is_template
  } })
}

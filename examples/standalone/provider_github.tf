locals {
  github_base_url = var.hostname != null ? "https://${var.hostname}" : null
}

provider "github" {
  token    = var.github_token
  base_url = local.github_base_url
  owner    = var.name
}

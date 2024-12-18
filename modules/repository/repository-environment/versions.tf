terraform {
  required_version = ">= 0.14.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6"
    }
  }
}

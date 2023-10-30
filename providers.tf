provider "aws" {
  default_tags {
    tags = {
      Terraform = "true"
    }
  }

  region = var.aws_management_account.organizations.default_region

  allowed_account_ids = [var.aws_management_account.organizations.management_account_id]

  # The management account doesn't have the OrganizationAccountAccessRole, so we
  # can't assume it. Instead, this module must be used with credentials that are
  # already targeting the management account.
}

provider "github" {
  token    = local.token
  base_url = "https://${var.hostname}"
  owner    = var.name
}

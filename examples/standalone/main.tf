module "this" {
  source = "../..//module"

  repositories = var.repositories

  organization_rulesets = var.organization_rulesets
}

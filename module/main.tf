module "github_repository" {
  for_each = var.repositories

  source = "../modules//repository"

  name = each.key

  description = each.value.description

  is_template            = each.value.is_template
  archived               = each.value.archived
  allow_auto_merge       = each.value.allow_auto_merge
  allow_merge_commit     = each.value.allow_merge_commit
  allow_rebase_merge     = each.value.allow_rebase_merge
  allow_squash_merge     = each.value.allow_squash_merge
  delete_branch_on_merge = each.value.delete_branch_on_merge
  has_issues             = each.value.has_issues
  has_projects           = each.value.has_projects
  has_wiki               = each.value.has_wiki
  visibility             = each.value.visibility
  pages                  = each.value.pages
  template               = each.value.template
  environments           = each.value.environments
  rulesets               = each.value.rulesets
}

module "organization_rulesets" {
  for_each = { for ruleset in var.organization_rulesets : ruleset.name => ruleset }
  source   = "../modules//organization-ruleset"


  ruleset = each.value
}

resource "github_repository" "this" {
  #checkov:skip=CKV2_GIT_1: TODO

  name        = var.name
  description = var.description

  is_template                 = var.is_template
  auto_init                   = var.auto_init
  archived                    = var.archived
  archive_on_destroy          = true
  allow_auto_merge            = var.allow_auto_merge
  allow_merge_commit          = var.allow_merge_commit
  merge_commit_title          = var.merge_commit_title
  merge_commit_message        = var.merge_commit_message
  allow_rebase_merge          = var.allow_rebase_merge
  allow_squash_merge          = var.allow_squash_merge
  squash_merge_commit_title   = var.squash_merge_commit_title
  squash_merge_commit_message = var.squash_merge_commit_message
  delete_branch_on_merge      = var.delete_branch_on_merge
  has_downloads               = var.has_downloads
  has_issues                  = var.has_issues
  has_projects                = var.has_projects
  has_wiki                    = var.has_wiki

  #checkov:skip=CKV_GIT_1: repository does not have to be private
  visibility = var.visibility

  vulnerability_alerts = var.archived ? false : var.vulnerability_alerts
  allow_update_branch  = true

  dynamic "pages" {
    for_each = var.pages == null ? [] : [1]

    content {
      source {
        branch = var.pages.source.branch
        path   = var.pages.source.path == null ? "/" : var.pages.source.path
      }
    }
  }

  dynamic "template" {
    for_each = var.template == null ? [] : [1]

    content {
      owner      = var.template.owner
      repository = var.template.repository
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

module "environments" {
  for_each = var.environments == null ? {} : var.environments

  source = "./repository-environment//"

  name                = each.key
  repository_name     = github_repository.this.name
  wait_timer          = each.value.wait_timer
  reviewers           = each.value.reviewers
  secrets             = each.value.secrets
  variables           = each.value.variables
  branch_patterns     = each.value.branch_patterns
  tag_patterns        = each.value.tag_patterns
  prevent_self_review = each.value.prevent_self_review
}

module "rulesets" {
  for_each = { for ruleset in var.rulesets : ruleset.name => ruleset }
  source   = "./repository-ruleset//"

  repository_name = var.name

  ruleset = each.value
}

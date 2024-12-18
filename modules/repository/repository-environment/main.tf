resource "github_repository_environment" "this" {
  environment = var.name
  repository  = var.repository_name
  wait_timer  = var.wait_timer

  dynamic "reviewers" {
    for_each = var.reviewers == null ? [] : [1]
    content {
      users = var.reviewers.users
      teams = var.reviewers.teams
    }
  }

  deployment_branch_policy {
    protected_branches     = var.branch_patterns == null || length(var.branch_patterns) == 0 ? true : false
    custom_branch_policies = var.branch_patterns == null || length(var.branch_patterns) == 0 ? false : true
  }
}

resource "github_actions_environment_secret" "this" {
  for_each = var.secrets == null ? {} : var.secrets

  repository      = var.repository_name
  environment     = github_repository_environment.this.environment
  secret_name     = each.key
  encrypted_value = each.value
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each = var.branch_patterns == null || length(var.branch_patterns) == 0 ? {} : {
    for pattern in var.branch_patterns : pattern => pattern
  }

  repository     = var.repository_name
  environment    = var.name
  branch_pattern = each.key

  depends_on = [github_repository_environment.this]
}

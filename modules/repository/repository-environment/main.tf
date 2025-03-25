resource "github_repository_environment" "this" {
  environment         = var.name
  repository          = var.repository_name
  wait_timer          = var.wait_timer
  prevent_self_review = var.prevent_self_review

  dynamic "reviewers" {
    for_each = var.reviewers == null ? [] : [1]
    content {
      users = var.reviewers.users
      teams = var.reviewers.teams
    }
  }

  deployment_branch_policy {
    protected_branches     = can(var.branch_patterns) && length(var.branch_patterns) > 0 ? false : true
    custom_branch_policies = can(var.branch_patterns) && length(var.branch_patterns) > 0 ? true : false
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
  for_each = can(var.branch_patterns) && length(var.branch_patterns) > 0 ? {
    for pattern in var.branch_patterns : pattern => pattern
  } : {}

  repository     = var.repository_name
  environment    = var.name
  branch_pattern = each.key

  depends_on = [github_repository_environment.this]
}
resource "github_repository_environment_deployment_policy" "tag_pattern" {
  for_each = can(var.tag_patterns) && length(var.tag_patterns) > 0 ? {
    for pattern in var.tag_patterns : pattern => pattern
  } : {}

  repository  = var.repository_name
  environment = var.name
  tag_pattern = each.key

  depends_on = [github_repository_environment.this]
}
resource "github_actions_environment_variable" "this" {
  for_each = var.variables == null ? {} : var.variables

  repository    = var.repository_name
  environment   = github_repository_environment.this.environment
  variable_name = each.key
  value         = each.value

  depends_on = [github_repository_environment.this]
}

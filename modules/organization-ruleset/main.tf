variable "ruleset" {
  type = object({
    name        = string
    target      = string
    enforcement = string

    conditions = object({
      ref_name = object({
        include = optional(list(string), [])
        exclude = optional(list(string), [])
      })
      repository_name = object({
        include = optional(list(string), [])
        exclude = optional(list(string), [])
      })
    })

    bypass_actors = list(object({
      actor_id    = number
      actor_type  = string
      bypass_mode = optional(string, null)
    }))

    rules = optional(object({
      creation                      = optional(bool, false)
      deletion                      = optional(bool, false)
      non_fast_forward              = optional(bool, false)
      required_linear_history       = optional(bool, false)
      required_signatures           = optional(bool, false)
      update                        = optional(bool, false)
      update_allows_fetch_and_merge = optional(bool, false)

      branch_name_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, null)
      }), null)

      commit_author_email_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, null)
      }), null)
      commit_message_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, null)
      }), null)
      committer_email_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, null)
      }), null)
      pull_request = optional(object({
        dismiss_stale_reviews_on_push     = optional(bool, null)
        require_code_owner_review         = optional(bool, null)
        require_last_push_approval        = optional(bool, null)
        required_approving_review_count   = optional(number, 0)
        required_review_thread_resolution = optional(bool, null)
      }), null)
      required_deployments = optional(object({
        required_deployment_environments = list(string)
      }), null)
      required_status_checks = optional(object({
        required_checks = list(object({
          context        = string
          integration_id = optional(number, null)
        }))
        strict_required_status_checks_policy = optional(bool, null)
      }), null)
      required_workflows = optional(list(object({
        repository_id = string
        path          = string
        ref           = optional(string, "main")
      })), [])
      tag_name_pattern = optional(object({
        operator = string
        pattern  = string
        name     = optional(string, null)
        negate   = optional(bool, null)
      }), null)
      required_code_scanning = optional(list(object({
        required_code_scanning_tool = object({
          alerts_threshold          = string
          security_alerts_threshold = string
          tool                      = string
        })
      })), [])
    }), null)
  })
}

resource "github_organization_ruleset" "this" {
  name = var.ruleset.name

  target      = var.ruleset.target
  enforcement = var.ruleset.enforcement

  dynamic "conditions" {
    for_each = { _ = var.ruleset.conditions }
    content {
      ref_name {
        exclude = conditions.value.ref_name.exclude
        include = conditions.value.ref_name.include
      }
      repository_name {
        exclude = conditions.value.repository_name.exclude
        include = conditions.value.repository_name.include
      }
    }
  }

  dynamic "bypass_actors" {
    for_each = {
      for bypass_actor in var.ruleset.bypass_actors : "${bypass_actor.actor_id}-${bypass_actor.actor_type}" => bypass_actor
    }
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  dynamic "rules" {
    for_each = lookup(var.ruleset, "rules", null) != null ? { _ = "_" } : {}
    content {
      creation                = var.ruleset.rules.creation
      deletion                = var.ruleset.rules.deletion
      non_fast_forward        = var.ruleset.rules.non_fast_forward
      required_linear_history = var.ruleset.rules.required_linear_history
      required_signatures     = var.ruleset.rules.required_signatures
      update                  = var.ruleset.rules.update
      #       update_allows_fetch_and_merge = var.ruleset.rules.update

      dynamic "branch_name_pattern" {
        for_each = var.ruleset.rules.branch_name_pattern != null ? { _ = var.ruleset.rules.branch_name_pattern } : {}
        content {
          operator = branch_name_pattern.value.operator
          pattern  = branch_name_pattern.value.pattern
          name     = branch_name_pattern.value.name
          negate   = branch_name_pattern.value.negate
        }
      }
      dynamic "commit_author_email_pattern" {
        for_each = var.ruleset.rules.commit_author_email_pattern != null ? { _ = var.ruleset.rules.commit_author_email_pattern } : {}
        content {
          operator = commit_author_email_pattern.value.operator
          pattern  = commit_author_email_pattern.value.pattern
          name     = commit_author_email_pattern.value.name
          negate   = commit_author_email_pattern.value.negate
        }
      }
      dynamic "commit_message_pattern" {
        for_each = var.ruleset.rules.commit_message_pattern != null ? { _ = var.ruleset.rules.commit_message_pattern } : {}
        content {
          operator = commit_message_pattern.value.operator
          pattern  = commit_message_pattern.value.pattern
          name     = commit_message_pattern.value.name
          negate   = commit_message_pattern.value.negate
        }
      }

      dynamic "committer_email_pattern" {
        for_each = var.ruleset.rules.committer_email_pattern != null ? { _ = var.ruleset.rules.committer_email_pattern } : {}
        content {
          operator = committer_email_pattern.value.operator
          pattern  = committer_email_pattern.value.pattern
          name     = committer_email_pattern.value.name
          negate   = committer_email_pattern.value.negate
        }
      }
      dynamic "pull_request" {
        for_each = var.ruleset.rules.pull_request != null ? { _ = var.ruleset.rules.pull_request } : {}
        content {
          dismiss_stale_reviews_on_push     = pull_request.value.dismiss_stale_reviews_on_push
          require_code_owner_review         = pull_request.value.require_code_owner_review
          require_last_push_approval        = pull_request.value.require_last_push_approval
          required_approving_review_count   = pull_request.value.required_approving_review_count
          required_review_thread_resolution = pull_request.value.required_review_thread_resolution
        }
      }

      #       dynamic "required_deployments" {
      #         for_each = var.ruleset.rules.required_deployments != null ? { _ = var.ruleset.rules.required_deployments } : {}
      #         content {
      #           required_deployment_environments = required_deployments.value.required_deployment_environments
      #         }
      #       }

      dynamic "required_status_checks" {
        for_each = var.ruleset.rules.required_status_checks != null ? { _ = var.ruleset.rules.required_status_checks } : {}
        content {
          dynamic "required_check" {
            for_each = { for rc in required_status_checks.value.required_checks : "${rc.context}-${rc.integration_id}" => rc }
            content {
              context        = required_check.value.context
              integration_id = required_check.value.integration_id
            }
          }
          strict_required_status_checks_policy = required_status_checks.value.strict_required_status_checks_policy
        }
      }
      dynamic "required_workflows" {
        for_each = { for rw in var.ruleset.rules.required_workflows : "${rw.repository_id}-${rw.path}-${rw.ref}" => rw }
        content {
          required_workflow {
            repository_id = required_workflows.value.repository_id
            path          = required_workflows.value.path
            ref           = required_workflows.value.ref
          }
        }
      }
      dynamic "tag_name_pattern" {
        for_each = var.ruleset.rules.tag_name_pattern != null ? { _ = var.ruleset.rules.tag_name_pattern } : {}
        content {
          operator = tag_name_pattern.value.operator
          pattern  = tag_name_pattern.value.pattern
          name     = tag_name_pattern.value.name
          negate   = tag_name_pattern.value.negate
        }
      }

      #       required_code_scanning = optional(list(object({
      #         required_code_scanning_tool = object({
      #           alerts_threshold          = string
      #           security_alerts_threshold = string
      #           tool                      = string
      #         })
      #       })), [])
      #       [{required_code_scanning_tool = {tool = ""}}]

      dynamic "required_code_scanning" {
        #         for_each = var.ruleset.rules.required_code_scanning != [] ? { _ = "_" } : {}
        for_each = length(var.ruleset.rules.required_code_scanning) != 0 ? {} : {}
        content {
          dynamic "required_code_scanning_tool" {
            for_each = { for rcs in var.ruleset.rules.required_code_scanning : rcs.required_code_scanning_tool.tool => rcs }
            content {
              alerts_threshold          = required_code_scanning_tool.value.required_code_scanning_tool.alerts_threshold
              security_alerts_threshold = required_code_scanning_tool.value.required_code_scanning_tool.security_alerts_threshold
              tool                      = required_code_scanning_tool.value.required_code_scanning_tool.tool
            }
          }
        }
      }
      #       dynamic "required_code_scanning" {
      #         for_each = {for rcs in var.ruleset.rules.required_code_scannings : rcs.tool => rcs}
      #         content {
      #           required_code_scanning_tool = {
      #             alerts_threshold          = required_code_scanning.value.required_code_scanning_tool.alerts_threshold
      #             security_alerts_threshold = required_code_scanning.value.required_code_scanning_tool.security_alerts_threshold
      #             tool                      = required_code_scanning.value.required_code_scanning_tool.tool
      #           }
      #         }
      #       }
    }
  }
}

output "this" {
  value = github_organization_ruleset.this
}

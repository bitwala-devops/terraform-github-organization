variable "hostname" {
  description = "The DNS name of this organization's GitHub instance."
  type        = string
  #   default     = "github.com"
  default = null
}

variable "name" {
  description = "The name of this GitHub organization."
  type        = string
}

variable "repositories" {
  description = <<-EOT
  A map of objects describing the repositories to manage in this organization,
  where each key is the name of the repository and the object attributes are:

  * description - A description of the repository.
  * is_template - Set to `true` if the repository is a template repository.
  * archived - Set to `true` if the repository is a archived.
  * allow_auto_merge - Set to `false` to prevent the auto merge action for PRs.
  * allow_merge_commit - Set to `false` to prevent the merge action for PRs.
  * allow_rebase_merge - Set to `false` to prevent the rebase merge action for PRs.
  * allow_squash_merge - Set to `false` to prevent the squash action for PRs.
  * delete_branch_on_merge - Set to `true` to delete branches for closed PRs.
  * has_downloads - Set to `false` to disable (deprecated) downloads features.
  * has_issues - Set to `false` to disable GitHub Issues features.
  * has_projects - Set to `false` to disable GitHub Projects features.
  * has_wiki - Set to `false` to disable GitHub Wiki features.
  * visibility - Can be `public`, `private`, or `internal` (default).
  * pages - An object describing the repository's GitHub Pages configuration. The object attributes are as follows:
    * source -  An object describing the source branch and directory for the rendered Pages site. (Required)
      * branch - The repository branch used to publish the site's source files. (Required)
      * path - The repository directory from which the site publishes. (Default: "/")
  * template - An object describing the repository's template configuration, if one is used. The object attributes are as follows:
    * owner - Name of the owner of the template used to create the new repository. (Required)
    * repository - Name of the repository where to use as template. (Required)
  * environments - An object describing the environment(s) that the repository will have, and their configuration, including secrets.
  EOT

  type = map(object({
    description            = string
    is_template            = optional(bool)
    archived               = optional(bool)
    allow_auto_merge       = optional(bool)
    allow_merge_commit     = optional(bool)
    allow_rebase_merge     = optional(bool)
    allow_squash_merge     = optional(bool)
    delete_branch_on_merge = optional(bool)
    has_issues             = optional(bool)
    has_projects           = bool
    has_wiki               = bool
    visibility             = string

    pages = optional(object({
      source = object({
        branch = string
        path   = optional(string)
      })
    }))

    template = optional(object({
      owner      = string
      repository = string
    }))

    environments = optional(map(object({
      wait_timer          = optional(number)
      branch_patterns     = optional(list(string))
      tag_patterns        = optional(list(string))
      prevent_self_review = optional(bool)
      secrets             = optional(map(any))
      variables           = optional(map(any))

      reviewers = optional(object({
        teams = optional(list(string))
        users = optional(list(string))
      }))
    })))

    rulesets = optional(list(object({
      name        = string
      target      = string
      enforcement = string

      conditions = object({
        ref_name = object({
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
          required_checks = optional(list(object({
            context        = string
            integration_id = optional(number, null)
          })), [])
          strict_required_status_checks_policy = optional(bool, null)
        }), null)
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
    })), [])
  }))
  nullable = false
}

variable "organization_rulesets" {
  type = list(object({
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
  }))
  default = []
}

variable "github_token" {
  type = string
}

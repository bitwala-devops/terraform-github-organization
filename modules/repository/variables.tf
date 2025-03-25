variable "name" {
  description = "Name of the repository."
  type        = string
  nullable    = false
}

variable "description" {
  description = "Description of the repository."
  type        = string
  nullable    = false
}

variable "is_template" {
  description = "Set to `true` if the repository is a template repository."
  type        = bool
  default     = false
  nullable    = false
}

variable "archived" {
  description = "Set to `true` if the repository is a archived."
  type        = bool
  default     = false
  nullable    = false
}

variable "allow_auto_merge" {
  description = "Set to `false` to prevent the auto merge action for PRs"
  type        = bool
  default     = true
  nullable    = false
}

variable "allow_merge_commit" {
  description = "Set to `false` to prevent the merge action for PRs."
  type        = bool
  default     = false
  nullable    = false
}

variable "allow_rebase_merge" {
  description = "Set to `false` to prevent the rebase merge action for PRs."
  type        = bool
  default     = true
  nullable    = false
}

variable "allow_squash_merge" {
  description = "Set to `false` to prevent the squash action for PRs."
  type        = bool
  default     = false
  nullable    = false
}

variable "delete_branch_on_merge" {
  description = "Set to `true` to delete branches for closed PRs."
  type        = bool
  default     = true
  nullable    = false
}

variable "has_downloads" {
  description = "Set to `false` to disable (deprecated) downloads features."
  type        = bool
  default     = false
  nullable    = false
}

variable "has_issues" {
  description = "Set to `false` to disable GitHub Issues features."
  type        = bool
  default     = true
  nullable    = false
}

variable "has_projects" {
  description = "Set to `false` to disable GitHub Projects features."
  type        = bool
  nullable    = false
}

variable "has_wiki" {
  description = "Set to `false` to disable GitHub Wiki features."
  type        = bool
  nullable    = false
}

variable "visibility" {
  description = "Can be `public`, `private`, or `internal` (default)."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "internal", "private"], var.visibility)
    error_message = "Valid values for var: visibility are (public, internal, private)."
  }
  nullable = false
}

variable "pages" {
  description = <<-EOT
    An object describing the repository's GitHub Pages configuration. The object attributes are as follows:
    * source -  An object describing the source branch and directory for the rendered Pages site. (Required)
      * branch - The repository branch used to publish the site's source files. (Required)
      * path - The repository directory from which the site publishes. (Default: "/")
  EOT

  type = object({
    source = object({
      branch = string
      path   = optional(string)
    })
  })
  default = null
}

variable "template" {
  description = <<-EOT
    An object describing the repository's template configuration, if one is used. The object attributes are as follows:
    * owner - Name of the owner of the template used to create the new repository. (Required)
    * repository - Name of the repository where to use as template. (Required)
  EOT

  type = object({
    owner      = string
    repository = string
  })
  default = null
}

variable "vulnerability_alerts" {
  description = "Whether vulnerability alerts are enabled or not."
  type        = bool

  default = true
}

variable "merge_commit_title" {
  description = "Can be PR_TITLE or MERGE_MESSAGE for a default merge commit title."

  type    = string
  default = "MERGE_MESSAGE"
}

variable "merge_commit_message" {
  description = "Can be PR_BODY, PR_TITLE, or BLANK for a default merge commit message."

  type    = string
  default = "PR_TITLE"
}

variable "squash_merge_commit_title" {
  description = "Can be PR_TITLE or COMMIT_OR_PR_TITLE for a default squash merge commit title."

  type    = string
  default = "COMMIT_OR_PR_TITLE"
}

variable "squash_merge_commit_message" {
  description = "Can be PR_BODY, COMMIT_MESSAGES, or BLANK for a default squash merge commit message."

  type    = string
  default = "COMMIT_MESSAGES"
}

variable "auto_init" {
  description = "Set to true to produce an initial commit in the repository."

  type    = bool
  default = true
}

variable "environments" {
  description = <<EOF
An object describing the environment(s) that the repository will have, and their configuration, including secrets.
EOF

  type = map(object({
    wait_timer          = optional(number)
    prevent_self_review = optional(bool)
    reviewers = optional(object({
      teams = optional(list(string))
      users = optional(list(string))
    }))
    branch_patterns = optional(list(string))
    tag_patterns    = optional(list(string))
    secrets         = optional(map(any))
    variables       = optional(map(any))
  }))
  default = null
}

variable "rulesets" {
  type = list(object({
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
  }))
  default = null
}

variable "aws_management_account" {
  description = <<-EOT
  An object describing the AWS Organizations management account, which provides
  secrets for this Github organization in SSM Parameter Store.
  EOT

  type = object({
    organizations = object({
      default_region        = string
      management_account_id = string
    })
  })
}

variable "aws_ssm_parameter_path" {
  description = <<-EOT
  The SSM Parameter Store path for the GitHub OAuth / Personal Access Token. The
  token scope must permit management of repositories within this organization.
  EOT

  type = string
}

variable "hostname" {
  description = "The DNS name of this organization's GitHub instance."
  type        = string
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
      wait_timer      = optional(number)
      branch_patterns = optional(list(string))
      secrets         = optional(map(any))

      reviewers = optional(object({
        teams = optional(list(string))
        users = optional(list(string))
      }))
    })))
  }))
  nullable = false
}

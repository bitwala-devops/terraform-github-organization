<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | > 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_organization_ruleset.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_ruleset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ruleset"></a> [ruleset](#input\_ruleset) | n/a | <pre>object({<br/>    name        = string<br/>    target      = string<br/>    enforcement = string<br/><br/>    conditions = object({<br/>      ref_name = object({<br/>        include = optional(list(string), [])<br/>        exclude = optional(list(string), [])<br/>      })<br/>      repository_name = object({<br/>        include = optional(list(string), [])<br/>        exclude = optional(list(string), [])<br/>      })<br/>    })<br/><br/>    bypass_actors = list(object({<br/>      actor_id    = number<br/>      actor_type  = string<br/>      bypass_mode = optional(string, null)<br/>    }))<br/><br/>    rules = optional(object({<br/>      creation                      = optional(bool, false)<br/>      deletion                      = optional(bool, false)<br/>      non_fast_forward              = optional(bool, false)<br/>      required_linear_history       = optional(bool, false)<br/>      required_signatures           = optional(bool, false)<br/>      update                        = optional(bool, false)<br/>      update_allows_fetch_and_merge = optional(bool, false)<br/><br/>      branch_name_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/><br/>      commit_author_email_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/>      commit_message_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/>      committer_email_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/>      pull_request = optional(object({<br/>        dismiss_stale_reviews_on_push     = optional(bool, null)<br/>        require_code_owner_review         = optional(bool, null)<br/>        require_last_push_approval        = optional(bool, null)<br/>        required_approving_review_count   = optional(number, 0)<br/>        required_review_thread_resolution = optional(bool, null)<br/>      }), null)<br/>      required_deployments = optional(object({<br/>        required_deployment_environments = list(string)<br/>      }), null)<br/>      required_status_checks = optional(object({<br/>        required_checks = list(object({<br/>          context        = string<br/>          integration_id = optional(number, null)<br/>        }))<br/>        strict_required_status_checks_policy = optional(bool, null)<br/>      }), null)<br/>      required_workflows = optional(list(object({<br/>        repository_id = string<br/>        path          = string<br/>        ref           = optional(string, "main")<br/>      })), [])<br/>      tag_name_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/>      required_code_scanning = optional(list(object({<br/>        required_code_scanning_tool = object({<br/>          alerts_threshold          = string<br/>          security_alerts_threshold = string<br/>          tool                      = string<br/>        })<br/>      })), [])<br/>    }), null)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this"></a> [this](#output\_this) | n/a |
<!-- END_TF_DOCS -->

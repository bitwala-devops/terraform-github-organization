<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_environments"></a> [environments](#module\_environments) | ./repository-environment// | n/a |
| <a name="module_rulesets"></a> [rulesets](#module\_rulesets) | ./repository-ruleset// | n/a |

## Resources

| Name | Type |
|------|------|
| [github_actions_variable.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Set to `false` to prevent the auto merge action for PRs | `bool` | `true` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | Set to `false` to prevent the merge action for PRs. | `bool` | `false` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | Set to `false` to prevent the rebase merge action for PRs. | `bool` | `true` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | Set to `false` to prevent the squash action for PRs. | `bool` | `false` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | Set to `true` if the repository is a archived. | `bool` | `false` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | Set to true to produce an initial commit in the repository. | `bool` | `true` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | Set to `true` to delete branches for closed PRs. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the repository. | `string` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | An object describing the environment(s) that the repository will have, and their configuration, including secrets. | <pre>map(object({<br/>    wait_timer          = optional(number)<br/>    prevent_self_review = optional(bool)<br/>    reviewers = optional(object({<br/>      teams = optional(list(string))<br/>      users = optional(list(string))<br/>    }))<br/>    branch_patterns = optional(list(string))<br/>    tag_patterns    = optional(list(string))<br/>    secrets         = optional(map(any))<br/>    variables       = optional(map(any))<br/>  }))</pre> | `null` | no |
| <a name="input_has_downloads"></a> [has\_downloads](#input\_has\_downloads) | Set to `false` to disable (deprecated) downloads features. | `bool` | `false` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Set to `false` to disable GitHub Issues features. | `bool` | `true` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | Set to `false` to disable GitHub Projects features. | `bool` | n/a | yes |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | Set to `false` to disable GitHub Wiki features. | `bool` | n/a | yes |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | Set to `true` if the repository is a template repository. | `bool` | `false` | no |
| <a name="input_merge_commit_message"></a> [merge\_commit\_message](#input\_merge\_commit\_message) | Can be PR\_BODY, PR\_TITLE, or BLANK for a default merge commit message. | `string` | `"PR_TITLE"` | no |
| <a name="input_merge_commit_title"></a> [merge\_commit\_title](#input\_merge\_commit\_title) | Can be PR\_TITLE or MERGE\_MESSAGE for a default merge commit title. | `string` | `"MERGE_MESSAGE"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the repository. | `string` | n/a | yes |
| <a name="input_pages"></a> [pages](#input\_pages) | An object describing the repository's GitHub Pages configuration. The object attributes are as follows:<br/>* source -  An object describing the source branch and directory for the rendered Pages site. (Required)<br/>  * branch - The repository branch used to publish the site's source files. (Required)<br/>  * path - The repository directory from which the site publishes. (Default: "/") | <pre>object({<br/>    source = object({<br/>      branch = string<br/>      path   = optional(string)<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_rulesets"></a> [rulesets](#input\_rulesets) | n/a | <pre>list(object({<br/>    name        = string<br/>    target      = string<br/>    enforcement = string<br/><br/>    conditions = object({<br/>      ref_name = object({<br/>        include = optional(list(string), [])<br/>        exclude = optional(list(string), [])<br/>      })<br/>    })<br/><br/>    bypass_actors = list(object({<br/>      actor_id    = number<br/>      actor_type  = string<br/>      bypass_mode = optional(string, null)<br/>    }))<br/><br/>    rules = optional(object({<br/>      creation                      = optional(bool, false)<br/>      deletion                      = optional(bool, false)<br/>      non_fast_forward              = optional(bool, false)<br/>      required_linear_history       = optional(bool, false)<br/>      required_signatures           = optional(bool, false)<br/>      update                        = optional(bool, false)<br/>      update_allows_fetch_and_merge = optional(bool, false)<br/><br/>      branch_name_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/><br/>      commit_author_email_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/>      commit_message_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/>      committer_email_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/>      pull_request = optional(object({<br/>        dismiss_stale_reviews_on_push     = optional(bool, null)<br/>        require_code_owner_review         = optional(bool, null)<br/>        require_last_push_approval        = optional(bool, null)<br/>        required_approving_review_count   = optional(number, 0)<br/>        required_review_thread_resolution = optional(bool, null)<br/>      }), null)<br/>      required_deployments = optional(object({<br/>        required_deployment_environments = list(string)<br/>      }), null)<br/>      required_status_checks = optional(object({<br/>        required_checks = optional(list(object({<br/>          context        = string<br/>          integration_id = optional(number, null)<br/>        })), [])<br/>        strict_required_status_checks_policy = optional(bool, null)<br/>      }), null)<br/>      tag_name_pattern = optional(object({<br/>        operator = string<br/>        pattern  = string<br/>        name     = optional(string, null)<br/>        negate   = optional(bool, null)<br/>      }), null)<br/>      required_code_scanning = optional(list(object({<br/>        required_code_scanning_tool = object({<br/>          alerts_threshold          = string<br/>          security_alerts_threshold = string<br/>          tool                      = string<br/>        })<br/>      })), [])<br/>    }), null)<br/>  }))</pre> | `[]` | no |
| <a name="input_squash_merge_commit_message"></a> [squash\_merge\_commit\_message](#input\_squash\_merge\_commit\_message) | Can be PR\_BODY, COMMIT\_MESSAGES, or BLANK for a default squash merge commit message. | `string` | `"COMMIT_MESSAGES"` | no |
| <a name="input_squash_merge_commit_title"></a> [squash\_merge\_commit\_title](#input\_squash\_merge\_commit\_title) | Can be PR\_TITLE or COMMIT\_OR\_PR\_TITLE for a default squash merge commit title. | `string` | `"COMMIT_OR_PR_TITLE"` | no |
| <a name="input_template"></a> [template](#input\_template) | An object describing the repository's template configuration, if one is used. The object attributes are as follows:<br/>* owner - Name of the owner of the template used to create the new repository. (Required)<br/>* repository - Name of the repository where to use as template. (Required) | <pre>object({<br/>    owner      = string<br/>    repository = string<br/>  })</pre> | `null` | no |
| <a name="input_variables"></a> [variables](#input\_variables) | An object describing the repository's GitHub Actions repository variables. | `map(string)` | `{}` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Can be `public`, `private`, or `internal` (default). | `string` | `"private"` | no |
| <a name="input_vulnerability_alerts"></a> [vulnerability\_alerts](#input\_vulnerability\_alerts) | Whether vulnerability alerts are enabled or not. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_description"></a> [description](#output\_description) | Description of the repository. |
| <a name="output_full_name"></a> [full\_name](#output\_full\_name) | Full name of the repository, including organization. `org_name/repo_name` |
| <a name="output_is_template"></a> [is\_template](#output\_is\_template) | Set to `true` if the repository is a template repository |
<!-- END_TF_DOCS -->
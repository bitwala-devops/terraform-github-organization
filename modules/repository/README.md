<!-- BEGIN_TF_DOCS -->
<img src="../../../docs/images/nuri-logo.png" align="right" width="200px" />

# Nuri's Terraform Modules

[![Terraform](../../../docs/badges/terraform.svg)][terraform]
[![Conventional Commits](../../../docs/badges/conventional-commits.svg)][conventional-commits]

> Provide high-quality, reusable modules for Nuri's cloud infrastructure

[terraform]: https://www.terraform.io/
[conventional-commits]: https://conventionalcommits.org

## Description
Module to create GitHub repositories, with the option of creating environments or not inside the repo.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.5 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 4.20.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_environments"></a> [environments](#module\_environments) | git@github.bitwa.la:bitwala-bank-devops/infrastructure-modules//technology/github/repository_environment | v5.136.0 |

## Resources

| Name | Type |
|------|------|
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |

## Example usage
```terraform
module "github_repository" {
source = "git@github.bitwa.la:bitwala-bank-devops/infrastructure-modules//technology/github/repository?ref=vX.X.X"

name = "repo_name"

description = "Repository description..."

is_template            = false
archived               = false
allow_auto_merge       = false
allow_merge_commit     = true
allow_rebase_merge     = true
allow_squash_merge     = true
delete_branch_on_merge = true
has_downloads          = false
has_issues             = false
has_projects           = false
has_wiki               = false
visibility             = "internal"
pages                  = {
source = {
branch = "gh-pages"
path   = "/"
}
}
template               = {
owner      = "bitwala-bank"
repository = "service-template"
}
environments           = {
development = {
deployment_branch_policy = {
protected_branches     = false
custom_branch_policies = true
}
secrets = {
my_secret_one = "test_secret"
my_secret_two = "test_secret2"
}
}
}
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Set to `false` to prevent the auto merge action for PRs | `bool` | `true` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | Set to `false` to prevent the merge action for PRs. | `bool` | `false` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | Set to `false` to prevent the rebase merge action for PRs. | `bool` | `true` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | Set to `false` to prevent the squash action for PRs. | `bool` | `false` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | Set to `true` if the repository is a archived. | `bool` | `false` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | Set to `true` to delete branches for closed PRs. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the repository. | `string` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | An object describing the environment(s) that the repository will have, and their configuration, including secrets. | <pre>map(object({<br>    wait_timer = optional(number)<br>    reviewers = optional(object({<br>      teams = optional(list(string))<br>      users = optional(list(string))<br>    }))<br>    deployment_branch_policy = object({<br>      protected_branches     = bool<br>      custom_branch_policies = bool<br>    })<br>    secrets = optional(map(any))<br>  }))</pre> | `null` | no |
| <a name="input_has_downloads"></a> [has\_downloads](#input\_has\_downloads) | Set to `false` to disable (deprecated) downloads features. | `bool` | `true` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Set to `false` to disable GitHub Issues features. | `bool` | `true` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | Set to `false` to disable GitHub Projects features. | `bool` | n/a | yes |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | Set to `false` to disable GitHub Wiki features. | `bool` | n/a | yes |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | Set to `true` if the repository is a template repository. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the repository. | `string` | n/a | yes |
| <a name="input_pages"></a> [pages](#input\_pages) | An object describing the repository's GitHub Pages configuration. The object attributes are as follows:<br>* source -  An object describing the source branch and directory for the rendered Pages site. (Required)<br>  * branch - The repository branch used to publish the site's source files. (Required)<br>  * path - The repository directory from which the site publishes. (Default: "/") | <pre>object({<br>    source = object({<br>      branch = string<br>      path   = optional(string)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_template"></a> [template](#input\_template) | An object describing the repository's template configuration, if one is used. The object attributes are as follows:<br>* owner - Name of the owner of the template used to create the new repository. (Required)<br>* repository - Name of the repository where to use as template. (Required) | <pre>object({<br>    owner      = string<br>    repository = string<br>  })</pre> | `null` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Can be `public`, `private`, or `internal` (default). | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_description"></a> [description](#output\_description) | Description of the repository. |
| <a name="output_full_name"></a> [full\_name](#output\_full\_name) | Full name of the repository, including organization. `org_name/repo_name` |
| <a name="output_is_template"></a> [is\_template](#output\_is\_template) | Set to `true` if the repository is a template repository |

## License

Copyright &copy; 2022 Bitwala GmbH & Nuri

This project repository contains UNLICENSED, proprietary information. Any
sharing of the information contained herein, beyond our organization, is
strictly prohibited.
<!-- END_TF_DOCS -->
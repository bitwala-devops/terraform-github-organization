<!-- BEGIN_TF_DOCS -->
<img src="../../../docs/images/nuri-logo.png" align="right" width="200px" />

# Nuri's Terraform Modules

[![Terraform](../../../docs/badges/terraform.svg)][terraform]
[![Conventional Commits](../../../docs/badges/conventional-commits.svg)][conventional-commits]

> Provide high-quality, reusable modules for Nuri's cloud infrastructure

[terraform]: https://www.terraform.io/
[conventional-commits]: https://conventionalcommits.org

## Description
Module to create an environment and secret environmnets in a GitHub repository.

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

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_environment_secret.env_secrets](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_repository_environment.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment) | resource |

## Example usage
```terraform
module "environments" {
source = "git@github.bitwa.la:bitwala-bank-devops/infrastructure-modules//technology/github/repository_environment?ref=vX.X.X"

name                     = "development"
repository_name          = "repo_name"
wait_timer               = 1
reviewers                = {
users = ["github_user1_id", "github_user2_id"]
}
deployment_branch_policy = {
protected_branches     = true
custom_branch_policies = false
}
secrets                  = {
secret_name = "secret_value"
}
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_branch_policy"></a> [deployment\_branch\_policy](#input\_deployment\_branch\_policy) | An object with the deployment branch policy configuration for the environment:<br>* protected\_branches - (Required) Whether only branches with branch protection rules can deploy to this environment.<br>* custom\_branch\_policies - (Required) Whether only branches that match the specified name patterns can deploy to this environment. | <pre>object({<br>    protected_branches     = bool<br>    custom_branch_policies = bool<br>  })</pre> | <pre>{<br>  "custom_branch_policies": true,<br>  "protected_branches": true<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the environment. | `string` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Name of the repository where the environment belongs to. | `string` | n/a | yes |
| <a name="input_reviewers"></a> [reviewers](#input\_reviewers) | An object with the teams or users that are going to be reviewers for the environment:<br>* teams - (Optional) Up to 6 IDs for teams who may review jobs that reference the environment.<br>  Reviewers must have at least read access to the repository.<br>  Only one of the required reviewers needs to approve the job for it to proceed.<br>* users - (Optional) Up to 6 IDs for users who may review jobs that reference the environment.<br>  Reviewers must have at least read access to the repository.<br>  Only one of the required reviewers needs to approve the job for it to proceed. | <pre>object({<br>    teams = optional(list(string))<br>    users = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secrets that will be created in the repository environment to be accessed only there. | `map(any)` | `null` | no |
| <a name="input_wait_timer"></a> [wait\_timer](#input\_wait\_timer) | Amount of time to delay a job after the job is initially triggered, in minutes. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repo_env_name"></a> [repo\_env\_name](#output\_repo\_env\_name) | Name of the repository environment. |
| <a name="output_secrets_names"></a> [secrets\_names](#output\_secrets\_names) | List with the names of the secrets created in the environment. |

## License

Copyright &copy; 2022 Bitwala GmbH & Nuri

This project repository contains UNLICENSED, proprietary information. Any
sharing of the information contained herein, beyond our organization, is
strictly prohibited.
<!-- END_TF_DOCS -->
variable "name" {
  description = "Name of the environment."

  type = string
}

variable "repository_name" {
  description = "Name of the repository where the environment belongs to."

  type = string
}

variable "wait_timer" {
  description = "Amount of time to delay a job after the job is initially triggered, in minutes."

  type    = string
  default = null
}

variable "prevent_self_review" {
  description = "Set to `true` to prevent self review."

  type    = bool
  default = false
}

variable "reviewers" {
  description = <<-EOT
  An object with the teams or users that are going to be reviewers for the environment:
  * teams - (Optional) Up to 6 IDs for teams who may review jobs that reference the environment.
    Reviewers must have at least read access to the repository.
    Only one of the required reviewers needs to approve the job for it to proceed.
  * users - (Optional) Up to 6 IDs for users who may review jobs that reference the environment.
    Reviewers must have at least read access to the repository.
    Only one of the required reviewers needs to approve the job for it to proceed.
  EOT

  type = object({
    teams = optional(list(string))
    users = optional(list(string))
  })
  default = null
}

variable "branch_patterns" {
  description = "The name patterns that branches must match in order to deploy to the environment."

  type    = list(string)
  default = []
}
variable "tag_patterns" {
  description = "The name patterns that tags must match in order to deploy to the environment."

  type    = list(string)
  default = []
}

variable "secrets" {
  description = "Map of secrets that will be created in the repository environment to be accessed only there."

  type    = map(any)
  default = null
}


variable "variables" {
  description = "Map of variables that will be created in the repository environment to be accessed only there."

  type    = map(any)
  default = null
}

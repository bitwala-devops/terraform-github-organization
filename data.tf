data "aws_ssm_parameter" "token" {
  name = var.aws_ssm_parameter_path
}

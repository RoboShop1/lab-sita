resource "aws_ssm_parameter" "foo" {
  for_each = var.parameters

  name  = each.key
  type  = "String"
  value = each.value
  overwrite = true

  tags = {
    Name   = "${each.key}"
    access = var.access
  }
}

variable "access" {}

variable "parameters" {}

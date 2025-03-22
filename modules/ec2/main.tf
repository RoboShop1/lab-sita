
resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "${var.name}-${var.env}"
  }
}

variable "ami_id" {}
variable "instance_type" {}
variable "env" {}
variable "name" {}
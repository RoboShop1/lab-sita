data "aws_vpc" "default" {
  default = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.aws_vpc.default.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Interface"

  subnet_ids       = ["subnet-0843f25967fb0b18d","subnet-0e4185a248d6d0b4b"]
  security_group_ids = [
    "sg-00a30a397c35892b0"
  ]


  tags = {
    Name = "s3-endpoint"
  }
}
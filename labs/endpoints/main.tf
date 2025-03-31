data "aws_vpc" "default" {
  default = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id             = data.aws_vpc.default.id
  service_name       = "com.amazonaws.us-east-1.s3"
  route_table_ids    = ["rtb-03c73aa42bbbe049f"]
  vpc_endpoint_type  = "Gateway"
}

resource "aws_instance" "app" {
  ami             =  "ami-0b4f379183e5706b9"
  instance_type   = "t2.micro"
  subnet_id       = "subnet-0843f25967fb0b18d"
 vpc_security_group_ids = ["sg-0665a56c7cd09a0e0"]

  tags = {
    Name = "Instance"
  }
}
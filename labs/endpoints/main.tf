data "aws_vpc" "default" {
  default = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id             = data.aws_vpc.default.id
  service_name       = "com.amazonaws.us-west-2.ec2"
  subnet_ids         = ["subnet-0e4185a248d6d0b4b"]
  vpc_endpoint_type  = "Interface"
  security_group_ids = [
    "sg-00a30a397c35892b0"
  ]

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
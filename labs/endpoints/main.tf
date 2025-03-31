data "aws_vpc" "default" {
  default = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id             = data.aws_vpc.default.id
  service_name       = "com.amazonaws.us-west-1.ec2"
  subnet_ids         = ["subnet-0e4185a248d6d0b4b"]

}

resource "aws_instance" "app" {
  ami            =  "ami-0b4f379183e5706b9"
  instance_type  = "t2.micro"
  subnet_id      = "subnet-0843f25967fb0b18d"
  security_groups = ["sg-00a30a397c35892b0"]
  tags = {
    Name = "Instance"
  }
}
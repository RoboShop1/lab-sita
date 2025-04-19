
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



resource "aws_security_group" "ec2-sg" {
  name = "ec2-sg"
  description = "Allow ec2"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 22
    protocol = "-1"
  }

}

resource "aws_instance" "main" {
  ami = "ami-0b4f379183e5706b9"
  instance_type = "t3.small"
  subnet_id = "subnet-0843f25967fb0b18d"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  tags = {
    Name = "one"
  }
}
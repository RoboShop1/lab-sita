
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "s3_endpoint_sg" {
  name        = "s3-endpoint-sg"
  description = "Allow traffic from EC2 to S3 endpoint"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.aws_vpc.default.id
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  subnet_ids       = ["subnet-0843f25967fb0b18d","subnet-0e4185a248d6d0b4b"]
  security_group_ids = [aws_security_group.s3_endpoint_sg.id]
  tags = {
    Name = "ssm-endpoint"
  }
}



resource "aws_security_group" "ec2-sg" {
  name = "ec2-sg"
  description = "Allow ec2"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "main" {
  ami = "ami-0b4f379183e5706b9"
  instance_type = "t3.small"
  subnet_id = "subnet-0843f25967fb0b18d"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name

  tags = {
    Name = "one"
  }
}

output "two_ip" {
  value = aws_instance.main.private_ip
}


# resource "aws_instance" "two" {
#   ami = "ami-0b4f379183e5706b9"
#   instance_type = "t3.small"
#   subnet_id = "subnet-0e4185a248d6d0b4b"
#   vpc_security_group_ids = [aws_security_group.ec2-sg.id]
#   iam_instance_profile = aws_iam_instance_profile.test_profile.name
#
#   tags = {
#     Name = "two"
#   }
# }
#
#
# resource "aws_instance" "three" {
#   ami = "ami-0b4f379183e5706b9"
#   instance_type = "t3.small"
#   subnet_id = "subnet-0e4185a248d6d0b4b"
#   vpc_security_group_ids = [aws_security_group.ec2-sg.id]
#   iam_instance_profile = aws_iam_instance_profile.test_profile.name
#
#   tags = {
#     Name = "three"
#   }
# }
#
#
#

#
#
# output "three_ip" {
#   value = aws_instance.two.private_ip
# }
#
#
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "ssm:DescribeParameters",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
#
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.test_role.name
}
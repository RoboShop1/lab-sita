data "aws_vpc" "default" {
  default = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id             = data.aws_vpc.default.id
  service_name       = "com.amazonaws.us-east-1.s3"
  route_table_ids    = ["rtb-03c73aa42bbbe049f","rtb-0bbe806208db871cc"]
  vpc_endpoint_type  = "Gateway"
}

resource "aws_instance" "app" {
  ami             =  "ami-0b4f379183e5706b9"
  instance_type   = "t2.micro"
  subnet_id       = "subnet-0843f25967fb0b18d"
  vpc_security_group_ids = ["sg-0665a56c7cd09a0e0"]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name

  tags = {
    Name = "Instance"
  }
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
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

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.test_role.name
}















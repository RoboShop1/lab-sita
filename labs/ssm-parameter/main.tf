terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}
# resource "aws_ssm_parameter" "foo" {
#   for_each = var.parameters
#
#   name  = each.key
#   type  = "String"
#   value = each.value
#
#   tags = {
#     Name   = "${each.key}"
#     access = "chaitu"
#   }
# }


module "ssm" {
  for_each   = var.parameters
  source     = "./module"
  parameters = each.value
  access     = each.key
}



resource "aws_iam_user" "c" {
  name = "chaitu"
  tags = {
    Name   = "chaitu"
    access = "chaitu"
  }
}

resource "aws_iam_access_key" "access-chaitu" {
  user    = aws_iam_user.r.name
}

resource "null_resource" "chaitu" {

  triggers = {
    name = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOT

bash -c 'mkdir -p /tmp && echo "id = ${aws_iam_access_key.access-chaitu.id}" > /tmp/100.txt && echo "secret = ${aws_iam_access_key.access-chaitu.secret}" >> /tmp/100.txt'

"echo Hello-chaitu"
EOT
  }
}



resource "aws_iam_user_policy" "main-chaitu" {
  name = "ssm-chaitu-policy"
  user = aws_iam_user.c.id

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
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:PrincipalTag/access": "chaitu",
            "ssm:resourceTag/access": "chaitu"
          }
        }
      }
    ]
  })
}




resource "aws_iam_user" "r" {
  name = "renuka"
  tags = {
    Name   = "renuka"
    access = "renuka"
  }
}


resource "aws_iam_user_policy" "main-renuka" {
  name = "ssm-renuka-policy"
  user = aws_iam_user.r.id

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
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:PrincipalTag/access": "renuka",
            "ssm:resourceTag/access": "renuka"
          }
        }
      }
    ]
  })
}








variable "parameters" {
  default = {
    chaitu = {
      one   = "one"
      two   = "two"
      three = "three"
      four  = "four"
    }
    renuka = {
      five   = "five"
      six   = "six"
    }
  }
}

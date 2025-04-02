
provider "aws" {
  region = "us-east-1"
}

provider "random" {
  version = "~> 3.5"
}


resource "random_string" "password" {
  length = 15
  special = false
}


resource "aws_secretsmanager_secret" "password" {
  name = "RDS_PASSWORD"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = jsonencode(
    {
      "master_password" = random_string.password.result
    }
  )
}

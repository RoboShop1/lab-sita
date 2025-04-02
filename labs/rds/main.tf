data "aws_vpc" "default"{
  default = true
}
data "aws_kms_key" "key_alias" {
  key_id = "alias/my-secret-key"
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-main"
  subnet_ids = ["subnet-0e4185a248d6d0b4b","subnet-0843f25967fb0b18d"]

  tags = {
    Name = "rds-main"
  }
}

resource "random_string" "password" {
  length  = 10
  special = false
  min_lower = 1
  min_numeric = 0
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



resource "aws_security_group" "main" {
  name = "rds-main"
  vpc_id = data.aws_vpc.default.id

  ingress {
    to_port = 3306
    from_port  = 3306
    protocol  = "TCP"
    self      = true
  }
}



resource "aws_db_instance" "main" {
  identifier            = "mysql_lab"
  allocated_storage     = 10
  max_allocated_storage = 20
  storage_type          = "gp3"
  deletion_protection   = false
  publicly_accessible   = false
  storage_encrypted     = true
  kms_key_id            = data.aws_kms_key.key_alias.id
  db_subnet_group_name  = aws_db_subnet_group.default.name
  db_name               = "mydb"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  username              = "Admin123"
  port                  = 3306
  password              = random_string.password.result
  parameter_group_name  = "default.mysql8.0"
  skip_final_snapshot   = true

  vpc_security_group_ids = [
    aws_security_group.main.id
  ]
  lifecycle {
    ignore_changes = [
      password,
      username

    ]
  }
  tags = {
    "Environment" = "dev"
    "Name"        = "rds"
  }
}






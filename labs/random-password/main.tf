
resource "random_string" "random" {
  length           = 16
  special          = false
  override_special = "!@"
}



resource "random_string" "random1" {
  length           = 55
  special          = true
  override_special = "/@£$"
}



resource "aws_secretsmanager_secret" "example" {
  name = "example"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode({
    one = "${random_string.random.result}"
    one1 = "${random_string.random1.result}"
  })
}




output "one1" {
  value = random_string.random1.result
}


output "all" {
  value = random_string.random.result
}


data "aws_secretsmanager_secret" "by-name" {
  name = "example"
}

data "aws_secretsmanager_secret_version" "by-version-stage" {
  secret_id     = data.aws_secretsmanager_secret.by-name.id
  version_stage = "AWSCURRENT"
}

output "fix" {
  value = data.aws_secretsmanager_secret_version.by-version-stage.secret_string
  sensitive = true
}

resource "null_resource" "one" {
  provisioner "local-exec" {
    command =<<EOT
echo "${data.aws_secretsmanager_secret_version.by-version-stage.secret_string}" > /tmp/120.txt
EOT
  }
}
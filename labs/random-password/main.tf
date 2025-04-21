resource "random_string" "random" {
  length           = 16
  special          = false
  override_special = "!@"
}



resource "random_string" "random1" {
  length           = 50
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
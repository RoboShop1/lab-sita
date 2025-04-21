resource "random_string" "random" {
  length           = 16
  special          = false
  override_special = "!@"
}


output "all" {
  value = random_string.random.result
}
resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}


output "all" {
  value = random_string.random.result
}
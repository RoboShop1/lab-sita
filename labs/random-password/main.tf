resource "random_string" "random" {
  length           = 16
  special          = false
  override_special = "!@"
}



resource "random_string" "random1" {
  length           = 16
  special          = true
  override_special = "/@£$"
}


output "one1" {
  value = random_string.random1.result
}


output "all" {
  value = random_string.random.result
}
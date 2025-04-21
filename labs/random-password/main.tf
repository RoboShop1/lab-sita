resource "random_string" "random" {
  length           = 16
  special          = false
}


output "all" {
  value = random_string.random.result
}
resource "random_string" "random" {
  length           = 16
  special          = true
}


output "all" {
  value = random_string.random.result
}
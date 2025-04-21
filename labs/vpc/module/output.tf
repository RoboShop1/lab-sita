output "public_subnets" {
  value = aws_subnet.public_subnets
}


output "app_subnets" {
  value = aws_subnet.app_subnets
}

output "db_subnets" {
  value = aws_subnet.db_subnets
}
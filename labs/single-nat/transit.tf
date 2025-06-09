resource "aws_ec2_transit_gateway" "example" {
  description = "nat-dev-prod"
  tags = {
    Name = "nat-dev-prod"
  }
}
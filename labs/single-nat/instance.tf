
resource "aws_instance" "nat-public" {
  ami            = "ami-0b4f379183e5706b9"
  instance_type  = "t3.small"
  subnet_id      = aws_subnet.public.id


  tags = {
    Name = "nat-public-one"
  }
}


#

output "nat-public-ip" {
  value = aws_instance.nat-public.public_ip
}

resource "aws_instance" "dev-private" {
  ami            = "ami-0b4f379183e5706b9"
  instance_type  = "t3.small"
  subnet_id      = aws_subnet.dev-private.id


  tags = {
    Name = "dev-private-one"
  }
}


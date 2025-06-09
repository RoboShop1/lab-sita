resource "aws_ec2_transit_gateway" "example" {
  description = "nat-dev-prod"
  tags = {
    Name = "nat-dev-prod"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "nat-attachment" {
  subnet_ids         = [aws_subnet.private.id,aws_subnet.public.id]
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.nat-gw.id
}


resource "aws_ec2_transit_gateway_vpc_attachment" "dev-attachment" {
  subnet_ids         = [aws_subnet.dev-private.id]
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.dev.id
}

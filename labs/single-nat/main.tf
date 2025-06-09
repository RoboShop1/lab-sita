resource "aws_vpc" "nat-gw" {
  cidr_block       = "10.1.0.0/16"
  tags = {
    Name = "nat-gw"
  }
}



resource "aws_eip" "aws_eip" {
  domain   = "vpc"
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nat-gw.id
  tags = {
    Name = "nat--vpc-igw"
  }
}


resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.aws_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-vpc-nat"
  }
}


resource "aws_route_table" "nat-public-rt" {
  vpc_id = aws_vpc.nat-gw.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "10.2.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.example.id
  }

  tags = {
    Name = "nat-public-rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.nat-public-rt.id
}


resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.nat-gw.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "nat-gw-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.nat-gw.id
  cidr_block = "10.1.2.0/24"

  tags = {
    Name = "nat-gw-private"
  }
}

resource "aws_route_table" "nat-private-rt" {
  vpc_id = aws_vpc.nat-gw.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "nat-private-rt"
  }
}


resource "aws_route_table_association" "igw-rta-private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.nat-private-rt.id
}




                            #-------------#
                            #    dev      #
                            #-------------#

resource "aws_vpc" "dev" {
  cidr_block       = "10.2.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "dev-private" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.2.1.0/24"

  tags = {
    Name = "dev-private"
  }
}

resource "aws_route_table" "dev-private-rt" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "10.1.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.example.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.example.id
  }

  tags = {
    Name = "dev-private-rt"
  }
}

resource "aws_route_table_association" "dev-rta-private" {
  subnet_id      = aws_subnet.dev-private.id
  route_table_id = aws_route_table.dev-private-rt.id
}




                          #--------------#
                          #    prod      #
                          #--------------#

resource "aws_vpc" "prod" {
  cidr_block       = "10.3.0.0/16"
  tags = {
    Name = "prod-vpc"
  }
}
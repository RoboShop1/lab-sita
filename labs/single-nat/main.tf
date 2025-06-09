resource "aws_vpc" "nat-gw" {
  cidr_block       = "10.1.0.0/16"
  tags = {
    Name = "nat-gw"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nat-gw.id
  tags = {
    Name = "nat--vpc-igw"
  }
}


resource "aws_route_table" "nat-public-rt" {
  vpc_id = aws_vpc.nat-gw.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
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

  tags = {
    Name = "nat-private-rt"
  }
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


                          #--------------#
                          #    prod      #
                          #--------------#

resource "aws_vpc" "prod" {
  cidr_block       = "10.3.0.0/16"
  tags = {
    Name = "prod-vpc"
  }
}
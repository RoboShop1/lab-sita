resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-vpc"
  }
}


resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["az"]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-vpc-${each.key}-subnet"
  }
}


resource "aws_route_table" "public-rt" {
  for_each = aws_subnet.public_subnets
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-vpc-${each.key}-rt"
  }
}



// **** app subnets **** //


resource "aws_subnet" "app_subnets" {
  for_each          = var.app_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["az"]

  tags = {
    Name = "${var.env}-vpc-${each.key}-subnet"
  }
}


resource "aws_route_table" "app-rt" {
  for_each = aws_subnet.app_subnets
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "${var.env}-vpc-${each.key}-rt"
  }
}



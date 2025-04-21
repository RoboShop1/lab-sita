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


resource "aws_route_table_association" "public-rt-a" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value["id"]
  route_table_id = lookup(lookup(aws_route_table.public-rt,each.key,null),"id",null)
}


resource "aws_eip" "eip" {
  for_each = aws_subnet.public_subnets
  domain   = "vpc"

  tags = {
    Name = "${var.env}-vpc-${each.key}-eip"
  }
}


resource "aws_nat_gateway" "nat-gw" {
  for_each      = aws_subnet.public_subnets

  allocation_id = lookup(lookup(aws_eip.eip,each.key,null),"id",null)
  subnet_id     = each.value["id"]

  tags = {
    Name = "${var.env}-vpc-${each.key}-nat"
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

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = can(regex(1,each.key)) ? aws_nat_gateway.nat-gw["public1"].id: aws_nat_gateway.nat-gw["public2"].id
  }

  tags = {
    Name = "${var.env}-vpc-${each.key}-rt"
  }
}


resource "aws_route_table_association" "app-rt-a" {
  for_each       = aws_subnet.app_subnets
  subnet_id      = each.value["id"]
  route_table_id = lookup(lookup(aws_route_table.app-rt,each.key,null),"id",null)
}



resource "aws_subnet" "db_subnets" {
  for_each          = var.db_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["az"]

  tags = {
    Name = "${var.env}-vpc-${each.key}-subnet"
  }
}




resource "aws_route_table" "db-rt" {
  for_each = aws_subnet.db_subnets
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = can(regex(1,each.key)) ? aws_nat_gateway.nat-gw["public1"].id: aws_nat_gateway.nat-gw["public2"].id
  }

  tags = {
    Name = "${var.env}-vpc-${each.key}-rt"
  }
}

resource "aws_route_table_association" "db-rt-a" {
  for_each       = aws_subnet.db_subnets
  subnet_id      = each.value["id"]
  route_table_id = lookup(lookup(aws_route_table.db-rt,each.key,null),"id",null)
}
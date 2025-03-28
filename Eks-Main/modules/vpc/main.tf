resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  tags = {
    Name = "${var.env}-vpc"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-vpc-igw"
  }
}

// ******************** //
      // subnets //
// ******************* //


resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.main.id
  for_each          = var.public_subnets
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["az"]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-vpc-${each.key}"
  }
}

resource "aws_subnet" "app_subnets" {
  vpc_id            = aws_vpc.main.id
  for_each          = var.app_subnets
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["az"]

  tags = {
    Name = "${var.env}-vpc-${each.key}"
  }
}

resource "aws_subnet" "db_subnets" {
  vpc_id            = aws_vpc.main.id
  for_each          = var.db_subnets
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["az"]

  tags = {
    Name = "${var.env}-vpc-${each.key}"
  }
}


// ******************** //
// Nat gateway  //
// ******************* //

resource "aws_eip" "eip" {
  for_each = aws_subnet.public_subnets
  domain   = "vpc"

  tags = {
    Name =  "${var.env}-vpc-${each.key}-eip"
  }
}


resource "aws_nat_gateway" "example" {
  for_each      = aws_subnet.public_subnets
  allocation_id = lookup(lookup(aws_eip.eip,each.key,null),"id",null)
  subnet_id     = each.value["id"]

  tags = {
    Name =  "${var.env}-vpc-${each.key}-nat"
  }
  depends_on = [aws_internet_gateway.igw]
}


// ******************** //
      // routes //
// ******************* //

resource "aws_route_table" "public_rt" {
  vpc_id     = aws_vpc.main.id
  for_each   = aws_subnet.public_subnets
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env}-vpc-${each.key}-rt"
  }
}

resource "aws_route_table" "app_rt" {
  vpc_id     = aws_vpc.main.id
  for_each   = aws_subnet.app_subnets

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = can(regex(each.value,1)) ? aws_nat_gateway.example["public1"].id : aws_nat_gateway.example["public2"].id
  }

  tags = {
    Name = "${var.env}-vpc-${each.key}-rt"
  }
}

resource "aws_route_table" "db_rt" {
  vpc_id     = aws_vpc.main.id
  for_each   = aws_subnet.db_subnets
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = can(regex(each.value,1)) ? aws_nat_gateway.example["public1"].id : aws_nat_gateway.example["public2"].id
  }
  tags = {
    Name = "${var.env}-vpc-${each.key}-rt"
  }
}


















#================================================
#======================VPC=======================
#================================================

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_tag_name
  }
}

#================================================
#====================Subnets=====================
#================================================

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public1_subnet_cidr
  map_public_ip_on_launch = var.public1_subnet_map_public_ip_on_launch
  availability_zone       = var.AZ1

  tags = {
    Name = var.public1_subnet_tag_name
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public2_subnet_cidr
  map_public_ip_on_launch = var.public2_subnet_map_public_ip_on_launch
  availability_zone       = var.AZ2

  tags = {
    Name = var.public1_subnet_tag_name
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.private1_subnet_cidr
  map_public_ip_on_launch = var.private1_subnet_map_public_ip_on_launch
  availability_zone       = var.AZ1

  tags = {
    Name = var.private1_subnet_tag_name
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.private2_subnet_cidr
  map_public_ip_on_launch = var.private2_subnet_map_public_ip_on_launch
  availability_zone       = var.AZ2

  tags = {
    Name = var.private2_subnet_tag_name
  }
}

#================================================
#==================Internet_Gateway==============
#================================================

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igwgtf"
  }
}

#================================================
#==================Elastic_IP====================
#================================================

resource "aws_eip" "lb" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

#================================================
#================NAT_Internet_Gateway============
#================================================

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.igw]
}

#================================================
#================Public_Route_Table==============
#================================================


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "routetf"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.all_cidr
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

#================================================
#================Private_Route_Table=============
#================================================

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "routeptf"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.all_cidr
  gateway_id             = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

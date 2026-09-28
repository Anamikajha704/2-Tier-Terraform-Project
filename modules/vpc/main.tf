#vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
   instance_tenancy        = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

tags = {
    Name = "${var.project_name}-igw"
  }
}

data "aws_availability_zones" "available_zones" {}

#public subnet 1a
resource "aws_subnet" "public-sub-1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_sub_1a_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-sub-1a"
  
  }
}

#public subnet 2b
resource "aws_subnet" "public-sub-2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_sub_2b_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-sub-2b"
  
  }
}

#Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
  }
}


# associate public subnet public-sub-1a to public route table
resource "aws_route_table_association" "public-sub-1a_route_table_association" {
  subnet_id           = aws_subnet.public_sub_1a.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet public-sub-2b to public route table
resource "aws_route_table_association" "public-sub-2b_route_table_association" {
  subnet_id           = aws_subnet.public_sub_2b.id
  route_table_id      = aws_route_table.public_route_table.id
}

#private subnet 3a
resource "aws_subnet" "private_sub_3a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_sub_3a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-sub-3a"
  }
}

#private subnet 4b
resource "aws_subnet" "private_sub_4b" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_sub_4b_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-sub-4b"
  }
}

#private subnet 5a
resource "aws_subnet" "private_sub_5a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_sub_5a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-sub-5a"
  }
}

#private subnet 6b
resource "aws_subnet" "private_sub_6b" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_sub_6b_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-sub-6b"
  }
}


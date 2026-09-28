#allocate elastic ip for nat gateway
resource "aws_eip" "nat_1a_eip" {
  domain = "vpc"
  tags   = {
     Name = "${var.project_name}-nat-eip-1a" 
     }
}

resource "aws_eip" "nat_2b_eip" {
  domain = "vpc"
  tags   = { 
    Name = "${var.project_name}-nat-eip-2b" 
    }
}

#create nat gateway in public subnet 1a
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_1a_eip.id
  subnet_id     = var.public_subnet_1a_id
  tags          = { 
    Name = "${var.project_name}-nat-gw-1a" 
    }
    depends_on = [var.igw_id]
}

#create nat gateway in public subnet 2b
resource "aws_nat_gateway" "nat_2b" {
  allocation_id = aws_eip.nat_2b_eip.id
  subnet_id     = var.public_subnet_2b_id
  tags          = {
     Name = "${var.project_name}-nat-gw-2b" 
     }
     depends_on = [var.igw_id]
}


resource "aws_route_table" "private-route-a" {
  vpc_id = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_1a.id
  }
  tags   = {
    Name = "Private-route-a"
  }
}


resource "aws_route_table" "private-route-b" {
  vpc_id = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_2b.id
  }
  tags   = {
    Name = "Private-route-b"
  }
}

resource "aws_route_table_association" "private-sub-3a_route_table_association" {
  subnet_id           = var.private_subnet_3a_id
  route_table_id      = aws_route_table.private-route-a.id
}

resource "aws_route_table_association" "private-sub-5a_route_table_association" {
  subnet_id           = var.private_subnet_5a_id
  route_table_id      = aws_route_table.private-route-a.id
}

resource "aws_route_table_association" "private-sub-4b_route_table_association" {
  subnet_id           = var.private_subnet_4b_id
  route_table_id      = aws_route_table.private-route-b
}

resource "aws_route_table_association" "private-sub-6b_route_table_association" {
  subnet_id           = var.private_subnet_6b_id
  route_table_id      = aws_route_table.private-route-b.id
}


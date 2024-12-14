# Public Route Table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.myVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

# Private Route Table
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.myVpc.id

  tags = {
    Name = "private_route"
  }
}

# Private Route Table Associations
resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_subnet1.id # Corrected to private_subnet_1
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_subnet2.id # Corrected to private_subnet_2
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_association_3" {
  subnet_id      = aws_subnet.private_subnet3.id # Corrected to private_subnet_3
  route_table_id = aws_route_table.private_route.id
}

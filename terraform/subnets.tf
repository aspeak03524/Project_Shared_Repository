resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone["public_subnet_az"]

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = var.private_subnet_cidr_block_1
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone["private_subnet_az1"]

  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = var.private_subnet_cidr_block_2
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone["private_subnet_az2"]

  tags = {
    Name = "private_subnet2"
  }
}

resource "aws_subnet" "private_subnet3" {
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = var.private_subnet_cidr_block_3
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone["private_subnet_az3"]

  tags = {
    Name = "private_subnet3"
  }
}

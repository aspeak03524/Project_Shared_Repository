resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myVpc.id
  tags = {
    Name = "gw"
  }
}

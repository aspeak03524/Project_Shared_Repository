resource "aws_instance" "public_ec2" {
  ami                         = var.ami_image
  instance_type               = var.instance_type
  availability_zone           = "us-east-2a"
  vpc_security_group_ids      = [aws_security_group.public_security_group.id]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "andrew_public"
  }
}

resource "aws_instance" "private_ec2_1" {
  ami                    = var.ami_image
  instance_type          = var.instance_type
  availability_zone      = "us-east-2c"
  vpc_security_group_ids = [aws_security_group.private_security_group.id]
  subnet_id              = aws_subnet.private_subnet1.id # Ensure the subnet reference is correct

  tags = {
    Name = "andrew_private1"
  }
}

resource "aws_instance" "private_ec2_2" {
  ami                    = var.ami_image
  instance_type          = var.instance_type
  availability_zone      = "us-east-2c"
  vpc_security_group_ids = [aws_security_group.private_security_group.id]
  subnet_id              = aws_subnet.private_subnet2.id # Ensure the subnet reference is correct

  tags = {
    Name = "andrew_private2"
  }
}

output "public_ip_address" {
  value = aws_instance.public_ec2.public_ip
}

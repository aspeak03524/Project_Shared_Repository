# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Security group for the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Vote/Result Application Security Group
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Security group for Vote/Result applications"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from the ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  egress {
    description = "Allow outbound traffic to Redis"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.redis_subnet_cidr] # Use variable for Redis subnet CIDR block
  }

  egress {
    description = "Allow outbound traffic to Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.postgres_subnet_cidr] # Use variable for Postgres subnet CIDR block
  }
}

# Redis/Worker Security Group
resource "aws_security_group" "redis_worker_sg" {
  name        = "redis_worker_sg"
  description = "Security group for Redis and Worker instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow traffic to Redis port from App SG"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [
      aws_security_group.app_sg.id
    ]
  }

  egress {
    description = "Allow outbound traffic to Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.postgres_subnet_cidr] # Use variable for Postgres subnet CIDR block
  }
}

# Postgres Security Group
resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Security group for Postgres database"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow traffic from Worker SG to Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [
      aws_security_group.redis_worker_sg.id
    ]
  }

  ingress {
    description = "Allow traffic from App SG to Postgres (if needed directly)"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [
      aws_security_group.app_sg.id
    ]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Public Security Group
resource "aws_security_group" "public_security_group" {
  name        = "public_security_group"
  description = "Security group for public EC2 instances"
  vpc_id      = aws_vpc.myVpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private Security Group
resource "aws_security_group" "private_security_group" {
  name        = "private_security_group"
  description = "Security group for private EC2 instances"
  vpc_id      = aws_vpc.myVpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # Restrict to private network
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

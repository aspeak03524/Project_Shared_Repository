variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the ALB will be created"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block_1" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_block_2" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_block_3" {
  description = "CIDR block for the third private subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone" {
  description = "Availability zones for the subnets"
  type        = map(string)
  default = {
    public_subnet_az   = "us-east-2a"
    private_subnet_az1 = "us-east-2c"
    private_subnet_az2 = "us-east-2c"
    private_subnet_az3 = "us-east-2c"
  }
}

variable "region" {
  type        = string
  description = "Default region where infrastructures will be provisioned"
  default     = "us-east-2a"
}

variable "ami_image" {
  type        = string
  description = "AMI ID for the EC2 instances"
  default     = "ami-036841078a4b68e14"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instances"
  default     = "t2.micro"
}


variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs where the ALB will be placed"
}

variable "ssl_certificate_arn" {
  type        = string
  description = "The ARN of the SSL certificate to be used for HTTPS listener"
}

variable "redis_subnet_cidr" {
  description = "CIDR block for Redis subnet"
  type        = string
  default     = "10.0.2.0/24" # Replace with your actual CIDR block
}

variable "postgres_subnet_cidr" {
  description = "CIDR block for Postgres subnet"
  type        = string
  default     = "10.0.3.0/24" # Replace with your actual CIDR block
}

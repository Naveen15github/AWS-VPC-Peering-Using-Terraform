resource "aws_vpc" "vpc_a" {
  cidr_block           = var.vpc_a_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-A"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-A"
  }
}

resource "aws_route_table" "rt_a" {
  vpc_id = aws_vpc.vpc_a.id

  tags = {
    Name = "RT-A"
  }
}

resource "aws_route_table_association" "rta_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt_a.id
}

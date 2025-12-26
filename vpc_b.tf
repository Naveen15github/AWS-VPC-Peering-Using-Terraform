resource "aws_vpc" "vpc_b" {
  cidr_block           = var.vpc_b_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-B"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-B"
  }
}

resource "aws_route_table" "rt_b" {
  vpc_id = aws_vpc.vpc_b.id

  tags = {
    Name = "RT-B"
  }
}

resource "aws_route_table_association" "rta_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt_b.id
}

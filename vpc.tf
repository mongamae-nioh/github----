# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"
  tags                 = var.tags
}

# subnet
## public
resource "aws_subnet" "vpc-public-web" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)
  tags                 = var.tags
}

## private
resource "aws_subnet" "vpc-private-db" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)
  tags                 = var.tags
}

# RDS subnet group
resource "aws_db_subnet_group" "vpc-private-db" {
  name       = "vpc-private-db"
  subnet_ids = aws_subnet.vpc-private-db.*.id
  tags       = var.tags
}

# route table
resource "aws_route_table" "vpc-public-route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "vpc-public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.vpc-public-web.*.id, count.index)
  route_table_id = aws_route_table.vpc-public-route.id
}

# internet gateway
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]
  tags       = var.tags
}


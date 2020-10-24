# Security Group
resource "aws_security_group" "public-web-sg" {
  name   = "public-web-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.gip
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "public-web-sg"
  }
}

resource "aws_security_group" "private-db-sg" {
  name   = "private-db-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 5432 # PostgreSQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.public_subnets_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "private-db-sg"
  }
}

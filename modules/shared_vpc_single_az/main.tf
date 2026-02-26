resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.name}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

# Public subnet (hosts NAT)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-public"
  })
}

# Private subnets (dev/prod compute will live here)
resource "aws_subnet" "private_dev" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_dev_subnet_cidr
  availability_zone = var.az

  tags = merge(var.tags, {
    Name = "${var.name}-private-dev"
  })
}

resource "aws_subnet" "private_prod" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_prod_subnet_cidr
  availability_zone = var.az

  tags = merge(var.tags, {
    Name = "${var.name}-private-prod"
  })
}

# Public route table: 0.0.0.0/0 -> IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-rt-public"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway (shared)
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.nat.id

  tags = merge(var.tags, {
    Name = "${var.name}-nat"
  })

  depends_on = [aws_internet_gateway.this]
}

# Private route table: 0.0.0.0/0 -> NAT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-rt-private"
  })
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_dev" {
  subnet_id      = aws_subnet.private_dev.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_prod" {
  subnet_id      = aws_subnet.private_prod.id
  route_table_id = aws_route_table.private.id
}

# Shared Security Group for workspace compute (we'll reference this from dev/prod)
resource "aws_security_group" "workspace" {
  name        = "${var.name}-workspace-sg"
  description = "Shared security group for Databricks workspace compute"
  vpc_id      = aws_vpc.this.id

  # Allow all egress (common for private compute + NAT)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-workspace-sg"
  })
}
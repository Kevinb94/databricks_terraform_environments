# modules/shared_vpc_two_az/main.tf
#
# Two-AZ VPC layout with a SINGLE shared NAT Gateway (keeps cost down).
# - 1 VPC + 1 IGW
# - 2 public subnets (az1, az2)
# - 2 private dev subnets (az1, az2)
# - 2 private prod subnets (az1, az2)
# - 1 NAT Gateway in public subnet (az1)
# - Public RT -> IGW (associated to both public subnets)
# - Private RT -> NAT (associated to all private subnets)
# - Shared SG with all egress

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

# -------------------------
# Public subnets (2 AZs)
# -------------------------

resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_az1
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-public-${var.az1}"
  })
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_az2
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-public-${var.az2}"
  })
}

# -------------------------
# Private subnets (DEV, 2 AZs)
# -------------------------

resource "aws_subnet" "private_dev_az1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_dev_subnet_cidr_az1
  availability_zone = var.az1

  tags = merge(var.tags, {
    Name = "${var.name}-private-dev-${var.az1}"
  })
}

resource "aws_subnet" "private_dev_az2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_dev_subnet_cidr_az2
  availability_zone = var.az2

  tags = merge(var.tags, {
    Name = "${var.name}-private-dev-${var.az2}"
  })
}

# -------------------------
# Private subnets (PROD, 2 AZs)
# -------------------------

resource "aws_subnet" "private_prod_az1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_prod_subnet_cidr_az1
  availability_zone = var.az1

  tags = merge(var.tags, {
    Name = "${var.name}-private-prod-${var.az1}"
  })
}

resource "aws_subnet" "private_prod_az2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_prod_subnet_cidr_az2
  availability_zone = var.az2

  tags = merge(var.tags, {
    Name = "${var.name}-private-prod-${var.az2}"
  })
}

# -------------------------
# Public route table: 0.0.0.0/0 -> IGW
# -------------------------

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

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

# -------------------------
# NAT Gateway (SINGLE, in public AZ1)
# -------------------------

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  subnet_id     = aws_subnet.public_az1.id
  allocation_id = aws_eip.nat.id

  tags = merge(var.tags, {
    Name = "${var.name}-nat"
  })

  depends_on = [aws_internet_gateway.this]
}

# -------------------------
# Private route table: 0.0.0.0/0 -> NAT
# Associated to ALL private subnets (dev+prod, az1+az2)
# -------------------------

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

resource "aws_route_table_association" "private_dev_az1" {
  subnet_id      = aws_subnet.private_dev_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_dev_az2" {
  subnet_id      = aws_subnet.private_dev_az2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_prod_az1" {
  subnet_id      = aws_subnet.private_prod_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_prod_az2" {
  subnet_id      = aws_subnet.private_prod_az2.id
  route_table_id = aws_route_table.private.id
}

# -------------------------
# Shared Security Group for Databricks workspace compute
# -------------------------

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
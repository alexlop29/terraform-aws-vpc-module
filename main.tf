################################
# VPC
################################

resource "aws_vpc" "main" {
  cidr_block = var.ipv4_primary_cidr_block

  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    "Name" = var.name
  }
}

################################
# Internet Gateway
################################

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = var.name
  }
}

################################
# Default Route Table
################################

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    "Name" = var.name
  }
}

################################
# Public Routes
################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = var.name },
    { "Subnet" = "${var.name}-${var.public_subnet_suffix}" }
  )

}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id

  # NOTE: (alopez) Investigate the timeout options.
  timeouts {
    create = "5m"
  }
}

################################
# Private Routes
################################

# NOTE: (alopez) Return and double 
# check once the routes have been added. 

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = var.name },
    { "Subnet" = "${var.name}-${var.private_subnet_suffix}" }
  )
}

################################
# Public Subnet
################################

resource "aws_subnet" "public" {

  # NOTE: (alopez) Potential Bug; What if a user specifies 3 subnets, 2 AZs.

  count = length(var.public_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.public_subnets, count.index)

  tags = merge(
    { "Name" = var.name },
    { "Subnet" = "${var.name}-${var.public_subnet_suffix}" }
  )
}

################################
# Private Subnet
################################
resource "aws_subnet" "private" {

  # NOTE: (alopez) Potential Bug; What if a user specifies 3 subnets, 2 AZs.

  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.private_subnets, count.index)

  tags = merge(
    { "Name" = var.name },
    { "Subnet" = "${var.name}-${var.private_subnet_suffix}" }
  )
}

################################
# Network ACLs
################################

resource "aws_default_network_acl" "default" {
  # no rules defined, deny all traffic in this ACL

  default_network_acl_id = aws_vpc.main.default_network_acl_id

  tags = {
    "Name" = var.name
  }
}

################################
# Security Group
################################

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = var.name 
  }
}

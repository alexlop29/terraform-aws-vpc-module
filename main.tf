################################
# VPC
################################

resource "aws_vpc" "main" {
  count = var.create_vpc ? 1 : 0

  cidr_block          = var.use_ipam_pool ? null : var.ipv4_primary_cidr_block
  ipv4_ipam_pool_id   = var.ipv4_ipam_pool_id
  ipv4_netmask_length = var.ipv4_netmask_length

  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}

################################
# Internet Gateway
################################

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}

################################
# Security Group
################################

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}

################################
# Route Table
################################

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}



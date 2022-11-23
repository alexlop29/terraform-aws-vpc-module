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

################################################################
# Default Route Table
################################################################

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    "Name" = var.name
  }
}

################################################################
# Default Network ACL
################################################################

resource "aws_default_network_acl" "default" {
  # no rules defined, deny all traffic in this ACL

  default_network_acl_id = aws_vpc.main.default_network_acl_id

  tags = merge(
    { "Name" = "${var.name}" },
    { "VPC" = var.name }
  )
}

################################################################
# Default Security Group
################################################################

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = "${var.name}" },
    { "VPC" = var.name }
  )
}

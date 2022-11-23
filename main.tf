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
    { "Name" = "${var.name}-${var.public_subnet_suffix}" },
    { "VPC" = var.name }
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

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

################################
# Private Routes
################################

resource "aws_route_table" "private" {
  count = length(var.azs)

  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = "${var.name}-${var.private_subnet_suffix}" },
    { "VPC" = var.name }
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.azs)

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
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
    { "Name" = "${var.name}-${var.public_subnet_suffix}-${count.index}" },
    { "VPC" = var.name }
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
    { "Name" = "${var.name}-${var.private_subnet_suffix}-${count.index}" },
    { "VPC" = var.name }
  )
}

################################
# Default Network ACL
################################

resource "aws_default_network_acl" "default" {
  # no rules defined, deny all traffic in this ACL

  default_network_acl_id = aws_vpc.main.default_network_acl_id

  tags = merge(
    { "Name" = "${var.name}" },
    { "VPC" = var.name }
  )
}

################################
# Public Network ACLs
################################

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id

  subnet_ids = aws_subnet.public[*].id

  tags = merge(
    { "Name" = "${var.name}-${var.public_subnet_suffix}" },
    { "VPC" = var.name }
  )
}

resource "aws_network_acl_rule" "public_inbound" {
  count = length(var.public_inbound_acl_rules)

  network_acl_id = aws_network_acl.public.id

  egress          = false
  rule_number     = var.public_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.public_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.public_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.public_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.public_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.public_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.public_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.public_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.public_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "public_outbound" {
  count = length(var.public_outbound_acl_rules)

  network_acl_id = aws_network_acl.public.id

  egress          = true
  rule_number     = var.public_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.public_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.public_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.public_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.public_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.public_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.public_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.public_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.public_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

################################
# Private Network ACLs
################################

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id

  subnet_ids = aws_subnet.private[*].id

  tags = merge(
    { "Name" = "${var.name}-${var.private_subnet_suffix}" },
    { "VPC" = var.name }
  )
}

resource "aws_network_acl_rule" "private_inbound" {
  count = length(var.private_inbound_acl_rules)

  network_acl_id = aws_network_acl.private.id

  egress          = false
  rule_number     = var.private_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.private_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.private_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.private_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.private_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.private_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.private_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "private_outbound" {
  count = length(var.private_outbound_acl_rules)

  network_acl_id = aws_network_acl.private.id

  egress          = true
  rule_number     = var.private_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.private_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.private_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.private_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.private_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.private_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.private_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

################################
# Security Group
################################

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = "${var.name}" },
    { "VPC" = var.name }
  )
}

#############
# NAT Gateway
#############

resource "aws_eip" "nat_eip" {
  count = length(var.azs)

  vpc = true

  tags = merge(
    { "Name" = "${var.name}-nat-${count.index}" },
    { "VPC" = var.name }
  )

  depends_on = [aws_internet_gateway.default]
}

resource "aws_nat_gateway" "nat" {
  count = length(var.azs)

  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = merge(
    { "Name" = "${var.name}-nat-${count.index}" },
    { "VPC" = var.name }
  )

  depends_on = [aws_internet_gateway.default]
}

resource "aws_route" "private_nat_gateway" {
  count = length(var.azs)

  route_table_id         =  element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id         = element(aws_nat_gateway.nat[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

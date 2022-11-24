################################################################
# Private Routing Table and Routes
################################################################

resource "aws_route_table" "private" {
  count = length(var.azs)

  vpc_id = aws_vpc.main.id

  tags = merge({
    "Name"        = "${var.name}-${var.private_subnet_suffix}-${count.index}",
    "Environment" = var.environment
  })
}

resource "aws_route_table_association" "private" {
  count = length(var.azs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

################################################################
# Private Network ACLs
################################################################

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id

  tags = merge({
    "Name"        = "${var.name}-${var.private_subnet_suffix}",
    "Environment" = var.environment
  })
}

resource "aws_network_acl_rule" "private_inbound" {
  count = length(var.private_inbound_acl_rules)

  network_acl_id = aws_network_acl.private.id
  egress         = false

  rule_number = var.private_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.private_inbound_acl_rules[count.index]["rule_action"]
  from_port   = var.private_inbound_acl_rules[count.index]["from_port"]
  to_port     = var.private_inbound_acl_rules[count.index]["to_port"]
  protocol    = var.private_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = var.private_inbound_acl_rules[count.index]["cidr_block"]
}

resource "aws_network_acl_rule" "private_outbound" {
  count = length(var.private_outbound_acl_rules)

  network_acl_id = aws_network_acl.private.id
  egress         = true

  rule_number = var.private_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.private_outbound_acl_rules[count.index]["rule_action"]
  from_port   = var.private_outbound_acl_rules[count.index]["from_port"]
  to_port     = var.private_outbound_acl_rules[count.index]["to_port"]
  protocol    = var.private_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = var.private_outbound_acl_rules[count.index]["cidr_block"]
}

################################################################
# Private Subnet
################################################################

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnets[count.index]

  tags = merge({
    "Name"        = "${var.name}-${var.private_subnet_suffix}-${count.index}",
    "Environment" = var.environment
  })
}

################################################################
# Public Routing Table and Routes
################################################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    "Name"        = "${var.name}-${var.public_subnet_suffix}",
    "Environment" = var.environment
  })
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

################################################################
# Public Network ACLs
################################################################

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id

  tags = merge({
    "Name"        = "${var.name}-${var.public_subnet_suffix}",
    "Environment" = var.environment
  })
}

resource "aws_network_acl_rule" "public_inbound" {
  count = length(var.public_inbound_acl_rules)

  network_acl_id = aws_network_acl.public.id
  egress         = false

  rule_number = var.public_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.public_inbound_acl_rules[count.index]["rule_action"]
  from_port   = var.public_inbound_acl_rules[count.index]["from_port"]
  to_port     = var.public_inbound_acl_rules[count.index]["to_port"]
  protocol    = var.public_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = var.public_inbound_acl_rules[count.index]["cidr_block"]
}

resource "aws_network_acl_rule" "public_outbound" {
  count = length(var.public_outbound_acl_rules)

  network_acl_id = aws_network_acl.public.id
  egress         = true

  rule_number = var.public_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.public_outbound_acl_rules[count.index]["rule_action"]
  from_port   = var.public_outbound_acl_rules[count.index]["from_port"]
  to_port     = var.public_outbound_acl_rules[count.index]["to_port"]
  protocol    = var.public_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = var.public_outbound_acl_rules[count.index]["cidr_block"]
}


################################################################
# Public Subnet
################################################################

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.public_subnets[count.index]

  tags = merge({
    "Name"        = "${var.name}-${var.public_subnet_suffix}-${count.index}",
    "Environment" = var.environment
  })
}

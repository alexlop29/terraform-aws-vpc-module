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

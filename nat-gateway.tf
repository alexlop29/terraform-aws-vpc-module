################################################################
# NAT Gateway
################################################################

resource "aws_eip" "nat_eip" {
  count = length(var.azs)

  vpc        = true
  depends_on = [aws_internet_gateway.main]

  tags = merge({
    "Name"        = "${var.name}-nat-${count.index}",
    "Environment" = var.environment
  })
}

resource "aws_nat_gateway" "nat" {
  count = length(var.azs)

  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]

  tags = merge({
    "Name"        = "${var.name}-nat-${count.index}",
    "Environment" = var.environment
  })
}

resource "aws_route" "private_nat_gateway" {
  count = length(var.azs)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

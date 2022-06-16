# --------------------------------------------------------------------------------------------------
# Create NAT Gateway.
# --------------------------------------------------------------------------------------------------
resource "aws_eip" "default" {
  count = var.create_nat_gateway ? var.nat_gateway_count : 0
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s%s", local.prefix, "-eip-", count.index)
    }
  )
  depends_on    = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "default" {
  count         = var.create_nat_gateway ? var.nat_gateway_count : 0
  allocation_id = element(aws_eip.default.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s%s", local.prefix, "-nat-gw-", count.index)
    }
  )
}

resource "aws_route" "nat_gw" {
  count                  = var.create_nat_gateway ? length(aws_route_table.private.*.id) : 0
  route_table_id         = aws_route_table.private.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.default.*.id, count.index)
  depends_on             = [aws_route_table.private]
}

# --------------------------------------------------------------------------------------------------
# Create Public Gateway.
# --------------------------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count             = var.create_internet_gateway ? local.availability_zones_count : 0
  vpc_id            = aws_vpc.default.id
  availability_zone = element(var.availability_zones, count.index)

  cidr_block = cidrsubnet(
    signum(length(var.vpc_cidr)) == 1 ? var.vpc_cidr : join("", var.vpc_cidr),
    ceil(log(local.subnet_count * 2, 2)),
    local.subnet_count + count.index
  )

  tags = merge(
    local.tags,
    {
      "Name"  = format("%s%s%s", local.prefix, "-public-subnet-", local.az_map[element(var.availability_zones, count.index)]),
      "Scope" = "Public"
    },
    var.public_subnet_tags != null ? var.public_subnet_tags : {}
  )
}

resource "aws_route_table" "public" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.default.id

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s%s", local.prefix, "-public-rt-", local.az_map[element(var.availability_zones, count.index)])
    }
  )
}

resource "aws_route" "public" {
  count                  = var.create_internet_gateway ? 1 : 0
  route_table_id         = join("", aws_route_table.public.*.id)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_internet_gateway.gw.*.id, count.index)
  depends_on             = [aws_route_table.public]
}

resource "aws_route_table_association" "public" {
  count          = var.create_internet_gateway ? local.availability_zones_count : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.default.id
  subnet_ids = aws_subnet.public.*.id

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = local.tags
}

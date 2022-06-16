# --------------------------------------------------------------------------------------------------
# Create Private Subnet.
# --------------------------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  count             = local.availability_zones_count
  vpc_id            = aws_vpc.default.id
  availability_zone = element(var.availability_zones, count.index)

  cidr_block = cidrsubnet(
    signum(length(var.vpc_cidr)) == 1 ? var.vpc_cidr : join("", var.vpc_cidr),
    ceil(log(local.subnet_count * 2, 2)),
    count.index
  )

  tags = merge(
    local.tags,
    {
      "Name"  = format("%s%s%s", local.prefix, "-private-subnet-", local.az_map[element(var.availability_zones, count.index)]),
      "Scope" = "Private"
    },
    var.private_subnet_tags != null ? var.private_subnet_tags : {}
  )
}

resource "aws_route_table" "private" {
  count  = local.availability_zones_count
  vpc_id = aws_vpc.default.id

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s%s", local.prefix, "-private-rt-", local.az_map[element(var.availability_zones, count.index)])
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = local.availability_zones_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.default.id
  subnet_ids = aws_subnet.private.*.id

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

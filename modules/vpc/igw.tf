# --------------------------------------------------------------------------------------------------
# Create Internet Gateway.
# --------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "gw" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.default.id

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s", local.prefix, "-internet-gw")
    }
  )
}

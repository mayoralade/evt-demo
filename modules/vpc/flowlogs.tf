# --------------------------------------------------------------------------------------------------
# Create VPC Flow Log and CloudWatch Logs group.
# --------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = coalesce(var.vpc_log_group_name, "vpc-flow-logs-${lower(var.environment)}-${lower(replace(local.vpc_name, " ", "-"))}")
  retention_in_days = var.vpc_log_retention_in_days

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s", local.prefix, "-vpc-flowlogs-cwgroup")
    }
  )
}

resource "aws_cloudwatch_log_stream" "vpc_flow_logs" {
  name           = "${aws_cloudwatch_log_group.vpc_flow_logs.name}-logstream"
  log_group_name = aws_cloudwatch_log_group.vpc_flow_logs.name
}


resource "aws_flow_log" "default_vpc_flow_logs" {
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  iam_role_arn    = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_id          = aws_vpc.default.id
  traffic_type    = "ALL"

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s", local.prefix, "-vpc-flowlogs")
    }
  )
}

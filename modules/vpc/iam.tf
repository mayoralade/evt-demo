# --------------------------------------------------------------------------------------------------
# Create an IAM Role for publishing VPC Flow Logs into CloudWatch Logs group.
# --------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "vpc_flow_logs_publisher_assume_role_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_flow_logs_publisher" {
  name               = "${local.vpc_name}-VPC-Flow-Logs-Publisher"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_publisher_assume_role_policy.json
}

data "aws_iam_policy_document" "vpc_flow_logs_publish_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs_publish_policy" {
  name = "${local.vpc_name}-VPC-Flow-Logs-Publish-Policy"
  role = aws_iam_role.vpc_flow_logs_publisher.id

  policy = data.aws_iam_policy_document.vpc_flow_logs_publish_policy.json
}

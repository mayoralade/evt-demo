locals {
  availability_zones_count = length(var.availability_zones)
  subnet_count             = length(flatten(data.aws_availability_zones.available.*.names))
  prefix                   = "${var.project}-${var.environment}"
  vpc_name                 = "${local.prefix}-VPC"

  tags = {
    Environment = var.environment
    Project     = var.project
  }

  az_map = {
    "us-east-1"  = "us-east-1"
    "us-east-1a" = "us-east-1a"
    "us-east-1b" = "us-east-1b"
    "us-east-1c" = "us-east-1c"
    "us-east-1d" = "us-east-1d"
    "us-east-1e" = "us-east-1e"
    "us-east-1f" = "us-east-1f"
    "us-east-1g" = "us-east-1g"
    "us-east-1h" = "us-east-1h"

    "us-east-2"  = "us-east-2"
    "us-east-2a" = "us-east-2a"
    "us-east-2b" = "us-east-2b"
    "us-east-2c" = "us-east-2c"
    "us-east-2d" = "us-east-2d"
    "us-east-2e" = "us-east-2e"
    "us-east-2f" = "us-east-2f"
    "us-east-2g" = "us-east-2g"
    "us-east-2h" = "us-east-2h"

    "us-west-1"  = "us-west-1"
    "us-west-1a" = "us-west-1a"
    "us-west-1b" = "us-west-1b"
    "us-west-1c" = "us-west-1c"
    "us-west-1d" = "us-west-1d"
    "us-west-1e" = "us-west-1e"
    "us-west-1f" = "us-west-1f"
    "us-west-1g" = "us-west-1g"
    "us-west-1h" = "us-west-1h"

    "us-west-2"  = "us-west-2"
    "us-west-2a" = "us-west-2a"
    "us-west-2b" = "us-west-2b"
    "us-west-2c" = "us-west-2c"
    "us-west-2d" = "us-west-2d"
    "us-west-2e" = "us-west-2e"
    "us-west-2f" = "us-west-2f"
    "us-west-2g" = "us-west-2g"
    "us-west-2h" = "us-west-2h"
  }

}

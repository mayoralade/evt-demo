resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = {
    Name        = local.vpc_name
    Environment = var.environment
    Project     = var.project
  }

  lifecycle {
    prevent_destroy = false
  }
}

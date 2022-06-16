# --------------------------------------------------------------------------------------------------
# Create Base Security Group.
# --------------------------------------------------------------------------------------------------
resource "aws_security_group" "base" {
  name        = "base"
  description = "Base security group for all EC2 instances in ${local.vpc_name}"
  vpc_id      = aws_vpc.default.id

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s", local.prefix, "-base-security-group")
    }
  )
}

resource "aws_security_group_rule" "base_egress_dns_tcp" {
  description       = "DNS resolution"
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.base.id
}

resource "aws_security_group_rule" "base_egress_dns_udp" {
  description       = "DNS resolution"
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.base.id
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Base Security Group for SSH Access"
  vpc_id      = aws_vpc.default.id

  tags = merge(
    local.tags,
    {
      "Name" = format("%s%s", local.prefix, "-bastion-security-group")
    }
  )

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "bastion_ingress_ssh_tcp" {
  description       = "SSH Access"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = flatten([[var.vpc_cidr], var.external_cidr])
  security_group_id = aws_security_group.bastion.id
}

output "availability_zones" {
  description = "List of Availability Zones where subnets were created"
  value       = var.availability_zones
}

output "aws_region" {
  value       = data.aws_region.current.name
  description = "VPC region"
}

output "base_security_group_id" {
  value       = aws_security_group.base.id
  description = "EC2 base secuirty group id"
}

output "bastion_security_group_id" {
  value       = aws_security_group.bastion.id
  description = "EC2 bastion secuirty group id"
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways created"
  value       = aws_nat_gateway.default.*.id
}

output "private_route_table_ids" {
  description = "IDs of the created private route tables"
  value       = aws_route_table.private.*.id
}

output "public_route_table_ids" {
  description = "IDs of the created public route tables"
  value       = aws_route_table.public.*.id
}

output "private_subnets" {
  description = "Private subnet ids and cidrs"
  value       = {
    for subnet in aws_subnet.private:
    subnet.id => {
      name              = subnet.tags["Name"]
      availability_zone = subnet.availability_zone
      cidr_block        = subnet.cidr_block
    }
  }
}

output "public_subnets" {
  description = "Public subnet ids and cidrs"
  value       = {
    for subnet in aws_subnet.public:
    subnet.id => {
      name              = subnet.tags["Name"]
      availability_zone = subnet.availability_zone
      cidr_block        = subnet.cidr_block
    }
  }
}

output "vpc_id" {
  value       = aws_vpc.default.id
  description = "VPC id"
}

output "vpc_cidr" {
  value       = var.vpc_cidr
  description = "VPC cidr block"
}

output "eip_public_ip" {
  description = "Public IP Address of EIP"
  value       = try(aws_eip.default[0].public_ip, "")
}

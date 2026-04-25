output "vpc_id" {
  description = "The ID of My VPC"
  value       = aws_vpc.vpc01.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of My VPC"
  value       = aws_vpc.vpc01.cidr_block
}

output "private_subnet_01_id" {
  description = "The ID of My Private Subnet for Azname01"
  value       = aws_subnet.private_subnet_01.id
}

output "private_subnet_02_id" {
  description = "The ID of My Private Subnet for Azname02"
  value       = aws_subnet.private_subnet_02.id
}

output "private_subnet_sec_grp_01_id" {
  description = "The ID of Private Security Group 01"
  value       = aws_security_group.private_subnet_sec_grp_01.id
}

output "private_subnet_sec_grp_02_id" {
  description = "The ID of Private Security Group 02"
  value       = aws_security_group.private_subnet_sec_grp_02.id
}

output "resource_config_arn" {
  description = "Resource Configuration ARN"
  value       = aws_vpclattice_resource_configuration.resource_config_01.arn
}

output "resource_config_id" {
  description = "Resource Configuration ID"
  value       = aws_vpclattice_resource_configuration.resource_config_01.id
}

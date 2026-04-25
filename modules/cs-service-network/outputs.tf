output "vpc_id" {
  description = "The ID of My VPC"
  value       = aws_vpc.vpc02.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of My VPC"
  value       = aws_vpc.vpc02.cidr_block
}

output "private_subnet_02_id" {
  description = "The ID of My Private Subnet for Azname"
  value       = aws_subnet.private_subnet_02.id
}

output "private_subnet_sec_grp_02_id" {
  description = "The ID of My Private Security Group"
  value       = aws_security_group.private_subnet_sec_grp_02.id
}

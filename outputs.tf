# Global outputs

# rg-network module outputs
output "rg_network_vpc_id" {
  description = "The ID of the RG-Network VPC"
  value       = module.rg_network.vpc_id
}

output "rg_network_resource_config_arn" {
  description = "Resource Configuration ARN"
  value       = module.rg_network.resource_config_arn
}

output "rg_network_resource_config_id" {
  description = "Resource Configuration ID"
  value       = module.rg_network.resource_config_id
}

# cs-service-network module outputs
output "cs_service_network_vpc_id" {
  description = "The ID of the CS-ServiceNetwork VPC"
  value       = module.cs_service_network.vpc_id
}

output "cs_service_network_private_subnet_02_id" {
  description = "The ID of the CS-ServiceNetwork Private Subnet"
  value       = module.cs_service_network.private_subnet_02_id
}

# cs-private-ec2 module outputs
output "cs_private_ec2_private_ip" {
  description = "My Private Instance's Private IP address"
  value       = module.cs_private_ec2.private_ip
}

# Root module orchestrator
# Modules are wired in deployment sequence:
# 1. rg_network (no dependencies)
# 2. cs_service_network (depends on rg_network)
# 3. cs_private_ec2 (depends on cs_service_network)
# 4. ssm_endpoint (depends on cs_service_network)

module "rg_network" {
  source = "./modules/rg-network"
}

module "cs_service_network" {
  source             = "./modules/cs-service-network"
  resource_config_id = module.rg_network.resource_config_id

  depends_on = [module.rg_network]
}

module "cs_private_ec2" {
  source                    = "./modules/cs-private-ec2"
  private_subnet_id         = module.cs_service_network.private_subnet_02_id
  private_security_group_id = module.cs_service_network.private_subnet_sec_grp_02_id

  depends_on = [module.cs_service_network]
}

module "ssm_endpoint" {
  source           = "./modules/ssm-endpoint"
  vpc_id           = module.cs_service_network.vpc_id
  vpc_cidr_block   = module.cs_service_network.vpc_cidr_block
  private_subnet_id = module.cs_service_network.private_subnet_02_id

  depends_on = [module.cs_service_network]
}

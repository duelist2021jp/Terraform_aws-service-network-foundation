# Data source to resolve {{resolve:ssm:MyKMSKeyID}} from CloudFormation
data "aws_ssm_parameter" "my_kms_key_id" {
  name = "MyKMSKeyID"
}

# VPC
resource "aws_vpc" "vpc01" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC01"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_01" {
  vpc_id            = aws_vpc.vpc01.id
  cidr_block        = var.private_subnet_cidr_block_01
  availability_zone = var.azname01

  tags = {
    Name = "PrivateSubnet01"
  }
}

resource "aws_subnet" "private_subnet_02" {
  vpc_id            = aws_vpc.vpc01.id
  cidr_block        = var.private_subnet_cidr_block_02
  availability_zone = var.azname02

  tags = {
    Name = "PrivateSubnet02"
  }
}

# Route Tables
resource "aws_route_table" "private_rtbl_01" {
  vpc_id = aws_vpc.vpc01.id

  tags = {
    Name = "PrivateRtbl01"
  }
}

resource "aws_route_table" "private_rtbl_02" {
  vpc_id = aws_vpc.vpc01.id

  tags = {
    Name = "PrivateRtbl02"
  }
}

# Route Table Associations
resource "aws_route_table_association" "private_subnet_rtbl_assoc_01" {
  route_table_id = aws_route_table.private_rtbl_01.id
  subnet_id      = aws_subnet.private_subnet_01.id
}

resource "aws_route_table_association" "private_subnet_rtbl_assoc_02" {
  route_table_id = aws_route_table.private_rtbl_02.id
  subnet_id      = aws_subnet.private_subnet_02.id
}

# Security Groups
resource "aws_security_group" "resource_gateway_sec_grp" {
  description = "ResourceGatewaySecGrp"
  vpc_id      = aws_vpc.vpc01.id

  egress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ResourceGatewaySecGrp"
  }
}

resource "aws_security_group" "private_subnet_sec_grp_01" {
  description = "PrivateSecGrp01"
  vpc_id      = aws_vpc.vpc01.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.resource_gateway_sec_grp.id]
  }

  egress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PrivateSecGrp01"
  }
}

resource "aws_security_group" "private_subnet_sec_grp_02" {
  description = "PrivateSecGrp02"
  vpc_id      = aws_vpc.vpc01.id

  tags = {
    Name = "PrivateSecGrp02"
  }
}

# RDS DB Subnet Group
resource "aws_db_subnet_group" "rds_subnet_grp" {
  name        = "rdssubnetgrp"
  description = "DB Subnet Group for RDS Instance"
  subnet_ids  = [aws_subnet.private_subnet_01.id, aws_subnet.private_subnet_02.id]

  tags = {
    Name = "RDSSubnetGrp01"
  }

  depends_on = [aws_subnet.private_subnet_01, aws_subnet.private_subnet_02]
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "rds01" {
  instance_class               = "db.t3.small"
  identifier                   = "rds-pgsql"
  db_name                      = "db01"
  allocated_storage            = 20
  availability_zone            = var.azname01
  engine                       = "postgres"
  engine_version               = "16.6"
  manage_master_user_password  = true
  username                     = "postgres"
  master_user_secret_kms_key_id = data.aws_ssm_parameter.my_kms_key_id.value
  publicly_accessible          = false
  vpc_security_group_ids       = [aws_security_group.private_subnet_sec_grp_01.id]
  db_subnet_group_name         = aws_db_subnet_group.rds_subnet_grp.name
  network_type                 = "IPV4"
  storage_type                 = "gp2"
  skip_final_snapshot = true

  tags = {
    Name = "RDS01"
  }

  depends_on = [aws_db_subnet_group.rds_subnet_grp, aws_security_group.private_subnet_sec_grp_01]
}

# VPC Lattice Resource Gateway
resource "aws_vpclattice_resource_gateway" "resource_gateway_01" {
  name             = "my-rgw"
  ip_address_type  = "IPV4"
  security_group_ids = [aws_security_group.resource_gateway_sec_grp.id]
  subnet_ids       = [aws_subnet.private_subnet_01.id, aws_subnet.private_subnet_02.id]
  vpc_id           = aws_vpc.vpc01.id

  tags = {
    Name = "my-rgw"
  }

  depends_on = [aws_subnet.private_subnet_01, aws_subnet.private_subnet_02, aws_security_group.resource_gateway_sec_grp]
}

# VPC Lattice Resource Configuration
resource "aws_vpclattice_resource_configuration" "resource_config_01" {
  name                       = "my-rcf"
  type                       = "ARN"
  resource_gateway_identifier = aws_vpclattice_resource_gateway.resource_gateway_01.id

  resource_configuration_definition {
    arn_resource {
      arn = aws_db_instance.rds01.arn
    }
  }

  tags = {
    Name = "my-rcf"
  }

  depends_on = [aws_vpclattice_resource_gateway.resource_gateway_01, aws_db_instance.rds01]
}

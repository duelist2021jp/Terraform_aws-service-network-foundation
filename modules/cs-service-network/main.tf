# VPC
resource "aws_vpc" "vpc02" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC02"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet_02" {
  vpc_id            = aws_vpc.vpc02.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = var.azname

  tags = {
    Name = "PrivateSubnet02"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw02" {
  tags = {
    Name = "IGW02"
  }
}

# Internet Gateway Attachment
resource "aws_internet_gateway_attachment" "igw_attach_to_vpc" {
  internet_gateway_id = aws_internet_gateway.igw02.id
  vpc_id              = aws_vpc.vpc02.id

  depends_on = [aws_internet_gateway.igw02, aws_vpc.vpc02]
}

# NAT Gateway
resource "aws_nat_gateway" "ngw02" {
  connectivity_type = "public"
  availability_mode = "regional"
  vpc_id            = aws_vpc.vpc02.id

  tags = {
    Name = "NGW02"
  }

  depends_on = [aws_internet_gateway_attachment.igw_attach_to_vpc]
}

# Route Table
resource "aws_route_table" "private_rtbl_02" {
  vpc_id = aws_vpc.vpc02.id

  tags = {
    Name = "PrivateRtbl02"
  }
}

# Route - default route through NAT Gateway
resource "aws_route" "private_route_02" {
  route_table_id         = aws_route_table.private_rtbl_02.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw02.id

  depends_on = [aws_nat_gateway.ngw02, aws_route_table.private_rtbl_02]
}

# Route Table Association
resource "aws_route_table_association" "private_subnet_rtbl_assoc_02" {
  route_table_id = aws_route_table.private_rtbl_02.id
  subnet_id      = aws_subnet.private_subnet_02.id
}

# Security Groups
resource "aws_security_group" "private_subnet_sec_grp_02" {
  description = "Private-SecGrp"
  vpc_id      = aws_vpc.vpc02.id

  egress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PrivateSecGrp02"
  }
}

resource "aws_security_group" "service_network_endpoint_sec_grp" {
  description = "ServiceNetworkEndpoint-SecGrp"
  vpc_id      = aws_vpc.vpc02.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private_subnet_sec_grp_02.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.private_subnet_sec_grp_02.id]
  }

  egress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ServiceNetworkEndpointSecGrp"
  }

  depends_on = [aws_security_group.private_subnet_sec_grp_02]
}

# VPC Lattice Service Network
resource "aws_vpclattice_service_network" "service_network_01" {
  name      = "my-service-network"
  auth_type = "NONE"

  tags = {
    Name = "ServiceNetwork01"
  }
}

# VPC Lattice Service Network Resource Association
resource "aws_vpclattice_service_network_resource_association" "sn_resource_assoc_01" {
  service_network_identifier     = aws_vpclattice_service_network.service_network_01.id
  resource_configuration_identifier = var.resource_config_id

  depends_on = [aws_vpclattice_service_network.service_network_01]
}

# VPC Endpoint (ServiceNetwork type)
resource "aws_vpc_endpoint" "service_network_endpoint_01" {
  vpc_endpoint_type   = "ServiceNetwork"
  vpc_id              = aws_vpc.vpc02.id
  service_network_arn = aws_vpclattice_service_network.service_network_01.arn
  subnet_ids          = [aws_subnet.private_subnet_02.id]
  security_group_ids  = [aws_security_group.service_network_endpoint_sec_grp.id]
  private_dns_enabled = true

  tags = {
    Name = "ServiceNetworkEndpoint01"
  }

  depends_on = [aws_vpclattice_service_network.service_network_01, aws_subnet.private_subnet_02, aws_security_group.service_network_endpoint_sec_grp]
}

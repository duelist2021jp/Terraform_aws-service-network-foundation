# Security Group for VPC Endpoints (SSM)
resource "aws_security_group" "ssm_endpoint_sec_grp" {
  description = "Security Group for VPC Endpoint (SSM)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSMEndpoint-Security-Group"
  }
}

# VPC Endpoint for SSM
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  private_dns_enabled = true
  vpc_id              = var.vpc_id
  subnet_ids          = [var.private_subnet_id]
  security_group_ids  = [aws_security_group.ssm_endpoint_sec_grp.id]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "*"
        Resource  = "*"
      }
    ]
  })

  depends_on = [aws_security_group.ssm_endpoint_sec_grp]
}

# VPC Endpoint for SSM Messages
resource "aws_vpc_endpoint" "ssm_messages_endpoint" {
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  private_dns_enabled = true
  vpc_id              = var.vpc_id
  subnet_ids          = [var.private_subnet_id]
  security_group_ids  = [aws_security_group.ssm_endpoint_sec_grp.id]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "*"
        Resource  = "*"
      }
    ]
  })

  depends_on = [aws_security_group.ssm_endpoint_sec_grp]
}

# VPC Endpoint for EC2 Messages
resource "aws_vpc_endpoint" "ec2_messages_endpoint" {
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  private_dns_enabled = true
  vpc_id              = var.vpc_id
  subnet_ids          = [var.private_subnet_id]
  security_group_ids  = [aws_security_group.ssm_endpoint_sec_grp.id]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "*"
        Resource  = "*"
      }
    ]
  })

  depends_on = [aws_security_group.ssm_endpoint_sec_grp]
}

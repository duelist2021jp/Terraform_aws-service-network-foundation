variable "vpc_id" {
  description = "The ID of the VPC (replaces Fn::ImportValue for VPCId)"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC (replaces Fn::ImportValue for VPCCidrBlock)"
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet (replaces Fn::ImportValue for PrivateSubnet02ID)"
  type        = string
}

variable "aws_region" {
  description = "AWS Region for VPC Endpoint service names"
  type        = string
  default     = "ap-northeast-1"
}

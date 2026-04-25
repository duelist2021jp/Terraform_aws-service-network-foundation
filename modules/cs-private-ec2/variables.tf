variable "private_subnet_id" {
  description = "The ID of the private subnet (replaces Fn::ImportValue for PrivateSubnet02ID)"
  type        = string
}

variable "private_security_group_id" {
  description = "The ID of the private security group (replaces Fn::ImportValue for PrivateSubnetSecGrp02ID)"
  type        = string
}

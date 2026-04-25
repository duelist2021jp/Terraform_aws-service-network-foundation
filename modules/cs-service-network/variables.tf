variable "azname" {
  description = "Set 1st az-name"
  type        = string
  default     = "ap-northeast-1a"

  validation {
    condition     = contains(["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"], var.azname)
    error_message = "Allowed values are ap-northeast-1a, ap-northeast-1c, ap-northeast-1d."
  }
}

variable "vpc_cidr_block" {
  description = "VPC Cidr Block"
  type        = string
  default     = "20.0.0.0/16"
}

variable "private_subnet_cidr_block" {
  description = "Private Subnet Cidr Block for 1st az-name"
  type        = string
  default     = "20.0.1.0/24"
}

variable "resource_config_id" {
  description = "Resource Configuration ID from the rg-network stack (replaces Fn::ImportValue cross-stack reference)"
  type        = string
}

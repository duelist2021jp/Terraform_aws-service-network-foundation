variable "azname01" {
  description = "Set 1st az-name"
  type        = string
  default     = "ap-northeast-1a"

  validation {
    condition     = contains(["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"], var.azname01)
    error_message = "Allowed values are ap-northeast-1a, ap-northeast-1c, ap-northeast-1d."
  }
}

variable "azname02" {
  description = "Set 2nd az-name"
  type        = string
  default     = "ap-northeast-1c"

  validation {
    condition     = contains(["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"], var.azname02)
    error_message = "Allowed values are ap-northeast-1a, ap-northeast-1c, ap-northeast-1d."
  }
}

variable "vpc_cidr_block" {
  description = "VPC Cidr Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr_block_01" {
  description = "Private Subnet Cidr Block for 1st az-name"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block_02" {
  description = "Private Subnet Cidr Block for 2nd az-name"
  type        = string
  default     = "10.0.2.0/24"
}

variable "name" {
  description = "Name prefix for networking resources"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR (e.g. 10.10.0.0/16)"
  type        = string
}

variable "az" {
  description = "Single AZ to use (e.g. us-east-1a)"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR (for NAT Gateway)"
  type        = string
}

variable "private_dev_subnet_cidr" {
  description = "Private subnet CIDR for dev workspace"
  type        = string
}

variable "private_prod_subnet_cidr" {
  description = "Private subnet CIDR for prod workspace"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
variable "name" { type = string }
variable "vpc_cidr" { type = string }

variable "az1" { type = string }
variable "az2" { type = string }

variable "public_subnet_cidr_az1" { type = string }
variable "public_subnet_cidr_az2" { type = string }

variable "private_dev_subnet_cidr_az1" { type = string }
variable "private_dev_subnet_cidr_az2" { type = string }

variable "private_prod_subnet_cidr_az1" { type = string }
variable "private_prod_subnet_cidr_az2" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
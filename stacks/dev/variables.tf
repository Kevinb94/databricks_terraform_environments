variable "databricks_account_id" {
  type        = string
  description = "Databricks Account ID"
}

variable "env" {
  type        = string
  description = "Environment name (dev/prod)"
  default     = "dev"
}

variable "root_bucket_name" {
  type = string
}
variable "env" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

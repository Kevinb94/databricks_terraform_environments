variable "bucket_name" {
  description = "Globally-unique S3 bucket name for Databricks workspace root storage"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}
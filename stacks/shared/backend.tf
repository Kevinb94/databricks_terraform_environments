terraform {
  backend "s3" {
    bucket = "terraform-edw-state"
    key    = "databricks/shared/terraform.tfstate"
    region = "us-east-1"
  }
}
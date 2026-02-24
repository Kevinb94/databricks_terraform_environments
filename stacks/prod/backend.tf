terraform {
  backend "s3" {
    bucket = "terraform-edw-state"
    key    = "databricks/prod/terraform.tfstate"
    region = "us-east-1"
  }
}
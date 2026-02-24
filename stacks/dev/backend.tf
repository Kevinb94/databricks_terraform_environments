terraform {
  backend "s3" {
    bucket = "terraform-edw-state"
    key    = "databricks/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
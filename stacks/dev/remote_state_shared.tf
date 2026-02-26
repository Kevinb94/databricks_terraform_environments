data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "terraform-edw-state"
    key    = "databricks/shared/terraform.tfstate" # <-- use your *shared* stack key
    region = "us-east-1"
  }
}
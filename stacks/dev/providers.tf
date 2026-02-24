provider "aws" {
  region = "us-east-1"
}
provider "databricks" {
  alias         = "mws"
  host          = "https://accounts.cloud.databricks.com"
}


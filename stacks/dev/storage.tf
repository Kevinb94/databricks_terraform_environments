# stacks/dev/storage.tf

# Root bucket for the workspace (Databricks DBFS root)
resource "aws_s3_bucket" "root" {
  bucket = var.root_bucket_name

  tags = {
    env     = var.env
    project = "databricks_workspaces"
  }
}

# Recommended ownership controls (avoids ACL weirdness)
resource "aws_s3_bucket_ownership_controls" "root" {
  bucket = aws_s3_bucket.root.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Databricks provides the required bucket policy JSON
data "databricks_aws_bucket_policy" "root" {
  provider        = databricks.mws
  bucket          = aws_s3_bucket.root.bucket
  full_access_role = aws_iam_role.databricks_cross_account.arn
}

resource "aws_s3_bucket_policy" "root" {
  bucket = aws_s3_bucket.root.id
  policy = data.databricks_aws_bucket_policy.root.json
}

# Register the root bucket with Databricks Account (MWS)
resource "databricks_mws_storage_configurations" "dev" {
  provider                   = databricks.mws
  account_id                 = var.databricks_account_id
  storage_configuration_name = "dbx-${var.env}-storage"
  bucket_name                = aws_s3_bucket.root.bucket
}
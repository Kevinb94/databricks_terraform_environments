# stacks/dev/credentials.tf

############################################
# 1) Trust policy Databricks wants on the role
############################################
data "databricks_aws_assume_role_policy" "this" {
  provider    = databricks.mws
  external_id = var.databricks_account_id
}
# external_id is required here; account_id is not a valid arg for this data source. :contentReference[oaicite:1]{index=1}

############################################
# 2) IAM role in your AWS account
############################################
resource "aws_iam_role" "databricks_cross_account" {
  name               = "dbx-${var.env}-cross-account-role"
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
}

############################################
# 3) Permissions policy Databricks wants on the role
############################################
data "databricks_aws_crossaccount_policy" "this" {
  provider    = databricks.mws
  policy_type = "customer"
}

resource "aws_iam_role_policy" "databricks_cross_account" {
  name   = "dbx-${var.env}-cross-account-policy"
  role   = aws_iam_role.databricks_cross_account.id
  policy = data.databricks_aws_crossaccount_policy.this.json
}

############################################
# 4) Register that role in Databricks Account (MWS)
############################################
resource "databricks_mws_credentials" "dev" {
  provider         = databricks.mws
  account_id       = var.databricks_account_id
  credentials_name = "dbx-${var.env}-credentials"

  # REQUIRED: top-level attribute (no nested role block)
  role_arn = aws_iam_role.databricks_cross_account.arn

  depends_on = [aws_iam_role_policy.databricks_cross_account]
}
# role_arn is required here per the official resource docs/guide. :contentReference[oaicite:2]{index=2}
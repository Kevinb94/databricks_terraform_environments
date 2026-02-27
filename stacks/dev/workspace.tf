# stacks/dev/workspace.tf

resource "databricks_mws_workspaces" "dev" {
  provider      = databricks.mws
  account_id    = var.databricks_account_id
  workspace_name = "dbx-${var.env}-workspace"
  aws_region     = var.aws_region

  # Wire up the prerequisite MWS objects
  credentials_id           = databricks_mws_credentials.dev.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.dev.storage_configuration_id
  network_id               = databricks_mws_networks.dev.network_id
}

output "workspace_id" {
  value = databricks_mws_workspaces.dev.workspace_id
}

output "workspace_url" {
  value = databricks_mws_workspaces.dev.workspace_url
}
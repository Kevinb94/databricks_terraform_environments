resource "databricks_mws_networks" "dev" {
  provider     = databricks.mws
  account_id   = var.databricks_account_id
  network_name = "dbx-dev-network"

  vpc_id             = data.terraform_remote_state.shared.outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.shared.outputs.private_dev_subnet_ids
  security_group_ids = [data.terraform_remote_state.shared.outputs.workspace_security_group_id]
}
# # Prod will go here next
# module "root_bucket" {
#   source      = "../../modules/aws_root_bucket"
#   bucket_name = var.root_bucket_name

#   tags = {
#     env     = "prod"
#     project = "databricks_workspaces"
#   }
# }

data "databricks_mws_workspaces" "all" {
  provider = databricks.mws
}

output "workspace_ids" {
  value = data.databricks_mws_workspaces.all.ids
}
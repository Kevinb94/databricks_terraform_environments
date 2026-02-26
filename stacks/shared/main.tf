module "network" {
  source = "../../modules/shared_vpc_two_az"

  name     = "dbx-shared"
  vpc_cidr = "10.10.0.0/16"

  az1 = "us-east-1a"
  az2 = "us-east-1b"

  public_subnet_cidr_az1 = "10.10.1.0/24"
  public_subnet_cidr_az2 = "10.10.2.0/24"

  private_dev_subnet_cidr_az1  = "10.10.11.0/24"
  private_dev_subnet_cidr_az2  = "10.10.21.0/24"

  private_prod_subnet_cidr_az1 = "10.10.12.0/24"
  private_prod_subnet_cidr_az2 = "10.10.22.0/24"

  tags = {
    project = "databricks_workspaces"
  }
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_dev_subnet_ids" {
  value = module.network.private_dev_subnet_ids
}

output "private_prod_subnet_ids" {
  value = module.network.private_prod_subnet_ids
}

output "workspace_security_group_id" {
  value = module.network.workspace_security_group_id
}
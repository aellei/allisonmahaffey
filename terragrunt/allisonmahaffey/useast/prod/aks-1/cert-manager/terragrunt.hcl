include "root" {
  path = find_in_parent_folders()
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  cell_vars    = read_terragrunt_config(find_in_parent_folders("_cell.hcl"))
  azure_resource_group   = local.account_vars.locals.azure_resource_group
  cluster_prefix = local.cell_vars.locals.cluster_prefix
}

dependency "aks" {
  config_path = "${get_terragrunt_dir()}/../aks"
}

terraform {
  source = ".//."
}

inputs = {
  cluster_prefix = local.cluster_prefix
  azure_resource_group = local.azure_resource_group
  default_clusterissuer_email = "ops@akolades.com"
  }


terraform {
  source = ".//."
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  azure_resource_group   = local.account_vars.locals.azure_resource_group
  storage_account_name = local.account_vars.locals.storage_account_name
  azure_region       = local.region_vars.locals.azure_region
}

inputs = {
  azure_resource_group   = local.azure_resource_group
  storage_account_name = local.storage_account_name
  azure_region       = local.azure_region
  storage_container_name = "tf-state"
}

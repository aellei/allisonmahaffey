# TODO: check the networking

include "root" {
  path = find_in_parent_folders()
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  vpc_vars     = read_terragrunt_config(find_in_parent_folders("vpc.hcl"))
  azure_resource_group   = local.account_vars.locals.azure_resource_group
  azure_region       = local.region_vars.locals.azure_region
  network_name = local.vpc_vars.locals.network_name
}

terraform {
  source = "tfr:///Azure/network/azurerm//?version=5.3.0"
}

inputs = {
  resource_group_name = local.azure_resource_group
  resource_group_location = local.azure_region
  address_spaces      = ["10.8.4.0/22"] //TODO check
  subnet_prefixes     = ["10.8.4.0/23", "10.8.6.0/23"] //TODO check
  subnet_names        = ["terragrunt-iac-azr-1", "terragrunt-iac-azr-2"] //TODO check
  
  use_for_each = true
  tags = {
    cluster = "azr-myth-public-1"
  }
}

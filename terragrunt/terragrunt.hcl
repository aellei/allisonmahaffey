# Prevent directly running terraform commands in the root directory
skip = true

locals {
  account_vars         = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars          = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  azure_resource_group = local.account_vars.locals.azure_resource_group
  azure_region         = local.region_vars.locals.azure_region
  storage_account_name = local.account_vars.locals.storage_account_name
}

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.gen.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = local.azure_resource_group
    storage_account_name = local.storage_account_name
    container_name       = "tf-state"
    #container_name = "${get_env("TF_BUCKET_PREFIX", "")}terraform-state-${local.azure_resource_group}-${local.azure_region}"
    key = "azure/${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "azure_provider" {
  path      = "azure_provider.gen.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider azurerm {
      features {}
    }
  EOF
}

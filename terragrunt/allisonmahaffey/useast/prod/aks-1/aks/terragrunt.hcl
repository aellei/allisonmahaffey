# TODO: Cluster size
# TODO: Node size
# TODO: arm64 instead of amd64?
# TODO: make the cluster production ready

include "root" {
  path = find_in_parent_folders()
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  vpc_vars     = read_terragrunt_config(find_in_parent_folders("vpc.hcl"))
  cell_vars    = read_terragrunt_config(find_in_parent_folders("_cell.hcl"))
  azure_resource_group   = local.account_vars.locals.azure_resource_group
  azure_region       = local.region_vars.locals.azure_region
  cluster_prefix = local.cell_vars.locals.cluster_prefix
}

terraform {
  source = "tfr:///Azure/aks/azurerm//?version=9.4.1"
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../vpc"
}

inputs = {
  prefix = local.cluster_prefix
  resource_group_name = local.azure_resource_group
  resource_group_location = local.azure_region
  log_analytics_workspace_enabled = false
  role_based_access_control_enabled = true
  only_critical_addons_enabled = true

  # AAD RBAC Configuration
  rbac_aad = false
  rbac_aad_managed = false

  local_account_disabled = false 
  oidc_issuer_enabled = false
  workload_identity_enabled = false
  identity_type = "SystemAssigned"

  network_plugin = "azure"
  vnet_subnet_id        = dependency.vpc.outputs.vnet_subnets[0]

   upgrade_settings = {
    max_surge = "25%"   # No surge nodes - reduces vCPU quota needs
    max_unavailable = "0"  # Allow 1 node to be unavailable during upgrade
  }

  node_pools = {
    user_ = {
      name = "user"
      vm_size = "Standard_D2ps_v5"
      os_sku = "Ubuntu"
      enable_auto_scaling = true
      min_count = 0
      max_count = 1
      vnet_subnet_id        = dependency.vpc.outputs.vnet_subnets[0]

      node_taints = []

      upgrade_settings = {
        max_surge = "25%"
        max_unavailable = "0"
        drain_timeout_in_minutes = 10
        node_soak_duration_in_minutes = 10
      }
    }
  }
 }


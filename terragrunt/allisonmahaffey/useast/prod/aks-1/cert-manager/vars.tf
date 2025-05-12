variable "cluster_prefix" {
  type        = string
}

variable "azure_resource_group" {
  type        = string
  description = "Azure resource group name"
}

variable "namespace" {
  type    = string
  default = "cert-manager"
}


variable "create_namespace" {
  type        = bool
  default     = true
  description = "Create the kubernetes namespace if it doesn't already exist"
}

variable "helm_release_name" {
  type    = string
  default = "cert-manager"
}

variable "helm_repository" {
  type    = string
  default = "https://charts.jetstack.io"
}

variable "helm_chart" {
  type    = string
  default = "cert-manager"
}

variable "helm_chart_version" {
  type    = string
  default = "1.17.1"
}

variable "service_account_name" {
  type    = string
  default = "cert-manager"
}

variable "install_CRDs" {
  type    = bool
  default = true
}

variable "helm_values" {
  type        = list(string)
  default     = []
  description = "List of values in raw yaml to pass to helm"
}

variable "use_webhook_host_network" {
  type    = bool
  default = false
}

variable "default_clusterissuer_email" {
  type        = string
  description = "email address to use in the default ClusterIssuer manifests"
}
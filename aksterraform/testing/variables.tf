///////////////////////////////////////////////////////
// Azure subscription specific (tenants, location, resource group, resource group tags etc.)
variable "tenant_id" {
  type = string
  default = "2f500ad4-c495-4ddc-aa05-d5a275079c79"
}

variable "tenant_id_active_directory" {
  type = string
  default = "c0909704-f485-48b2-9190-c27a0baa6228"
}

variable "location" {
  type = string
  default = "switzerlandnorth"
}

variable "resource_group_name" {
  type = string
  default = "luw-devtest"
}

variable "azure_kubernetes_tags" { 
    type = map
    description = "Tags to be propagated to a new resource group created by Kubernetes internally"

    default = {
        BusinessUnit = "GBS"
        project = "LUW"
        subaccount = "1116"
    }
}
///////////////////////////////////////////////////////
// Other Azure specific (cluster, registry, VM, app registrations etc.)
variable "cluster_vm_size" {
  type = string
  default = "Standard_DS3_v2"
}

variable "acr_registry_name" {
  type = string
  default = "luw2registry"
}

variable "cluster_name_prefix" {
  type = string
  default = "luw2"
}

variable "identifier_uris" {
  type = string
  default = "api://87fb1030-4494-4010-5643-aa4d5e6001c8"
}

variable "azuread_application_name" {
  type = string
  default = "LuwApp2"
}

variable "ingress_hostname_prefix" {
  type = string
  default = "luw-ingress"
}

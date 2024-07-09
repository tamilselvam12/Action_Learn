variable "tenant_id" {
  type = string
  default = "95e66ecc-f2c2-464b-84d9-8fda407bc923"
}

variable "acr_registry_name" {
  type = string
  default = "test"
}

variable "cluster_name_prefix" {
  type = string
  default = "reckittperf"
}

variable "cluster_vm_size" {
  type = string
  default = "Standard_D8_v3"
}

variable "resource_group_name" {
  type = string
  default = "rg-ibms2p-dev-ci-eastus"
}

variable "location" {
  type = string
  default = "East US"
}

variable "kubernetes_tags" { 
    type = map
    description = "Tags to be propagated to a new resource group created by Kubernetes internally"

    default = {
		tag1 = "value1"
		tag2 = "value2"
    }
}

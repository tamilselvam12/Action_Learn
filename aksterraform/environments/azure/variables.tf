variable "tenant_id" {
  type = string
  default = "95e66ecc-f2c2-464b-84d9-8fda407bc923"
}

variable "subscription_id" {
  type = string
  default = "6523272d-1e2f-4a46-ada4-1a202e3addd9"
}

variable "location" {
  type = string
  default = "East US"
}

variable "resource_group_name" {
  type = string
  default = "rg-ibms2p-dev-ci-eastus"
}


variable "cluster_vm_size" {
  type = string
  default = "Standard_D8_v3"
}


variable "cluster_name_prefix" {
  type = string
  default = "reckitt"
}

variable "identifier_uris" {
  type = string
  default = "api://reckitt-dev-weurope-001-uri"
}

variable "azuread_application_name" {
  type = string
  default = "reckitt-dev-weurope-001-uri-ci"
}

variable "identifier_uris_dataengine" {
  type = string
  default = "api://reckitt-dev-weurope-001-uri-dataengine"
}

variable "azuread_application_name_dataengine" {
  type = string
  default = "reckitt-dev-weurope-001-uri-ci-dataengine"
}

variable "ingress_hostname_prefix" {
  type = string
  default = "reckitt_dev_dev_ingress"
}
variable "storage_class_name" {
  type = string
  default = "default"
}

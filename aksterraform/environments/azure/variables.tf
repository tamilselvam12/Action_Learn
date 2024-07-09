variable "tenant_id" {
  type = string
  default = "95917aa5-d840-4443-a19e-aa3ad09d4bb5"
}

variable "subscription_id" {
  type = string
  default = "d6233897-5c9f-47f9-8507-6d4ada2d5183"
}

variable "location" {
  type = string
  default = "East US"
}

variable "resource_group_name" {
  type = string
  default = "S2P_GitHub_PoC"
}


variable "cluster_vm_size" {
  type = string
  default = "Standard_D8_v3"
}


variable "cluster_name_prefix" {
  type = string
  default = "zac002"
}

variable "identifier_uris" {
  type = string
  default = "api://zac002-dev-eastus-001-uri"
}

variable "azuread_application_name" {
  type = string
  default = "zac002-dev-eastus-001-uri-ci"
}

variable "identifier_uris_dataengine" {
  type = string
  default = "api://zac002-dev-eastus-001-uri-dataengine"
}

variable "azuread_application_name_dataengine" {
  type = string
  default = "zac002-dev-eastus-001-uri-ci-dataengine"
}

variable "ingress_hostname_prefix" {
  type = string
  default = "zac002_dev_ingress"
}
variable "storage_class_name" {
  type = string
  default = "default"
}

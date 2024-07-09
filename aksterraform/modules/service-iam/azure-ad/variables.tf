variable "tenant_id" {
  type = string
  default = "2f500ad4-c495-4ddc-aa05-d5a275079c79"
}

variable "tenant_id_active_directory" {
  type = string
  default = "c0909704-f485-48b2-9190-c27a0baa6228"
}

variable "resource_group_name" {
  type = string
  default = "luw-devtest"
}

variable "location" {
  type = string
  default = "switzerlandnorth"
}

variable "azuread_application_name" {
  type = string
  default = "LuwApp2"
}

variable "app_password" {
  type = string
  default = "VT=uSgbTanZhyz@%nL9Hpd+Tfay_MRV#"
}

variable "identifier_uris" {
  type = string
  default = "api://87fb1030-4494-4010-5643-aa4d5e6001c8"
}

variable "ingress_hostname_prefix" {
  type = string
  default = "luw-ingress"
}
variable "http_application_routing_zone_name" {
  type = string
  default = "http_application_routing_zone_name"
}

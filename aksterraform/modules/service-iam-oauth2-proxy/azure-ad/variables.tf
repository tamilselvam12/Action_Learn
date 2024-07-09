variable "tenant_id_active_directory" {
  type = string
  default = "c0909704-f485-48b2-9190-c27a0baa6228"
}
variable "azuread_application_id" {
  type = string
  default = "TODO"
}
variable "app_password" {
  type = string
  default = ""
}
variable "ingress_hostname_prefix" {
  type = string
  default = "luw-ingress"
}
variable "namespace" {
  type = string
  default = "infrastructure"
}
variable "http_application_routing_zone_name" {
  type = string
  default = "http_application_routing_zone_name"
}

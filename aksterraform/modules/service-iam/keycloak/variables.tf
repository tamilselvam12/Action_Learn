variable "storage_class_name" {
  type = string
  default = "default"
}
variable "keycloak_disk_name" {
  type = string
  default = "keycloakdisk"
}
variable "namespace" {
  type = string
  default = "infrastructure"
}
variable "ingress_class" {
  type = string
  default = "addon-http-application-routing"
}
variable "http_application_routing_zone_name" {
  type = string
  default = "http_application_routing_zone_name"
}
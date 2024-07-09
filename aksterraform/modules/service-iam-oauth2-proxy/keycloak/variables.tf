variable "namespace" {
  type = string
  default = "infrastructure"
}
variable "ingress_hostname_prefix" {
  type = string
  default = "keycloak"
}
variable "http_application_routing_zone_name" {
  type = string
  default = "http_application_routing_zone_name"
}
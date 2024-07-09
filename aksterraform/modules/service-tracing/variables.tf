variable "ingress_class" {
  type = string
  default = "addon-http-application-routing"
}
variable "namespace" {
  type = string
  default = "infrastructure"
}
variable "http_application_routing_zone_name" {
  type = string
  default = "http_application_routing_zone_name"
}
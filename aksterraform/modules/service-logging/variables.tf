variable "storage_class_name" {
  type = string
  default = "default"
}
variable "ingress_class" {
  type = string
  default = "addon-http-application-routing"
}
variable "namespace" {
  type = string
  default = "infrastructure"
}
variable "cloud_provider" {
  type = string
  default = "default"
}
variable "http_application_routing_zone_name" {
  type = string
  default = "http_application_routing_zone_name"
}
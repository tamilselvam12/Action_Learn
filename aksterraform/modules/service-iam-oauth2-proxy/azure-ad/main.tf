resource "helm_release" "ouauth2-proxy" {
  name  = "nginx-ouauth2"
  namespace = var.namespace
  chart = "${path.module}/../helm"

  set {
    name  = "OAUTH2_PROXY_PROVIDER"
    value = "azure"
  }

  set {
    name  = "OAUTH2_PROXY_AZURE_TENANT"
    value = var.tenant_id_active_directory
  }

  set {
    name  = "OAUTH2_PROXY_CLIENT_ID"
    value = var.azuread_application_id
  }

  set {
    name  = "OAUTH2_PROXY_CLIENT_SECRET"
    value = var.app_password
  }

  set {
    name  = "hostname_prefix"
    value = var.ingress_hostname_prefix
  }

  set {
    name  = "http_application_routing_zone_name"
	value = var.http_application_routing_zone_name
  }
}
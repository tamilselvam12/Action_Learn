# Create an application
resource "azuread_application" "ingress" {
  display_name = var.azuread_application_name
  identifier_uris = [var.identifier_uris]
  homepage        = "https://homepage"
  reply_urls      = ["https://${var.ingress_hostname_prefix}.${var.http_application_routing_zone_name}/oauth2/callback",
                     "https://kibana.${var.http_application_routing_zone_name}/oauth2/callback",
                     "https://jaeger.${var.http_application_routing_zone_name}/oauth2/callback",
					 "https://grafana.${var.http_application_routing_zone_name}/oauth2/callback"]
  logout_url      = "https://${var.ingress_hostname_prefix}.${var.http_application_routing_zone_name}/ui/logout"
  oauth2_allow_implicit_flow = true
  
  // Assign API permission (delegated): Microsoft Graph => User.Read
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    resource_access {
      id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }
}

resource "azuread_application_password" "ingress" {
  application_object_id = azuread_application.ingress.id
  description           = "My managed password"
  value                 = var.app_password
  end_date              = "2099-01-01T01:02:03Z"
}
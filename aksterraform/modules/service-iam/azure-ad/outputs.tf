output "app_password" {
  value = var.app_password
}
output "azuread_application_id" {
  value = azuread_application.ingress.application_id
}
output "keycloak_username" {
  value = "admin"
}
output "keycloak_password" {
  value = random_password.keycloak_password.result
}
output "keycloak_app_username" {
  value = "docin-user"
}
output "keycloak_app_password" {
  value = random_password.keycloak_app_password.result
}
# Kubernetes
// TODO: remove base64 encoding to align with IBM Cloud Deployment
output "client_key" {
  value = base64decode(module.cluster.kubernetes_client_key_base64)
}
resource "local_file" "client_key" {
  content  = base64decode(module.cluster.kubernetes_client_key_base64)
  filename = "../../output/client_key"
}
output "client_certificate" {
  value = base64decode(module.cluster.kubernetes_client_certificate_base64)
}
resource "local_file" "client_certificate" {
  content  = base64decode(module.cluster.kubernetes_client_certificate_base64)
  filename = "../../output/client_certificate"
}
output "ca_certificate" {
  value = base64decode(module.cluster.kubernetes_ca_certificate_base64)
}
resource "local_file" "ca_certificate" {
  content  = base64decode(module.cluster.kubernetes_ca_certificate_base64)
  filename = "../../output/ca_certificate"
}
output "kubernetes_host" {
  value = module.cluster.kubernetes_host
}
resource "local_file" "kubernetes_host" {
  content  = module.cluster.kubernetes_host
  filename = "../../output/kubernetes_host"
}


# KeyCloak
/* 
// Default implementation ueses AzureAD, to be uncommented when using KeyCloak
output "keycloak_username" {
  value = module.service-iam-keycloak.keycloak_username
}
resource "local_file" "keycloak_username" {
  content  = module.service-iam-keycloak.keycloak_username
  filename = "../../output/keycloak_username"
}
output "keycloak_password" {
  value = module.service-iam-keycloak.keycloak_password
}
resource "local_file" "keycloak_password" {
  content  = module.service-iam-keycloak.keycloak_password
  filename = "../../output/keycloak_password"
}
output "keycloak_app_username" {
  value = module.service-iam-keycloak.keycloak_app_username
}
resource "local_file" "keycloak_app_username" {
  content  = module.service-iam-keycloak.keycloak_app_username
  filename = "../../output/keycloak_app_username"
}
output "keycloak_app_password" {
  value = module.service-iam-keycloak.keycloak_app_password
}
resource "local_file" "keycloak_app_password" {
  content  = module.service-iam-keycloak.keycloak_app_password
  filename = "../../output/keycloak_app_password"
}
*/


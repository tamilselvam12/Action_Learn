output "kubernetes_client_key_base64" {
  value = azurerm_kubernetes_cluster.cluster.kube_config[0].client_key
}

output "kubernetes_client_certificate_base64" {
  value = azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate
}

output "kubernetes_ca_certificate_base64" {
  value = azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
}

output "http_application_routing_zone_name" {
  value = azurerm_kubernetes_cluster.cluster.addon_profile.0.http_application_routing.0.http_application_routing_zone_name
}

output "kubernetes_host" {
  value = azurerm_kubernetes_cluster.cluster.kube_config[0].host
}


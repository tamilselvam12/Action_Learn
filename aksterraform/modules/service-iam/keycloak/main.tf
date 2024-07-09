resource "random_password" "keycloak_password" {
  length = 16
  special = true
  override_special = "_%@"
}
resource "random_password" "keycloak_app_password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "helm_release" "keycloak-release" {
  name  = "keycloak-release"
  namespace = var.namespace
  chart = "${path.module}/helm"

  set {
    name  = "http_application_routing_zone_name"
	value = var.http_application_routing_zone_name
  }
  
  set {
    name  = "storageClassName"
	value = var.storage_class_name
  }
  
  set {
    name  = "persistent_volume_name"
    value = var.keycloak_disk_name
  }

  set {
    name  = "ingress_class"
	value = var.ingress_class
  }

  set {
    name  = "secrets.KEYCLOAK_PASSWORD"
	value = random_password.keycloak_password.result
  }
  
  set {
    name  = "secrets.DEFUALT_APP_PASSWORD"
	value = random_password.keycloak_app_password.result
  }
}
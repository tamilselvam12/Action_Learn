resource "helm_release" "vault" {
  name  = "vault"
  namespace = var.namespace
  chart = "./vault-0.28.0.tgz"
  
  set {
    name  = "server.dataStorage.storageClass"
	value = var.storage_class_name
  }

  values = [
    file("${path.module}/values-vault.yaml")
  ]
}
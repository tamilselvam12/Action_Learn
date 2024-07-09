resource "helm_release" "ingress" {
  name  = "ingress"
  namespace = var.namespace
  chart = "https://github.com/kubernetes/ingress-nginx/releases/download/ingress-nginx-3.15.2/ingress-nginx-3.15.2.tgz"

  set {
    name  = "controller.replicaCount"
    value = "1"
  }
}
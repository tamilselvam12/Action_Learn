resource "kubernetes_namespace" "infrastructure" {
  metadata {
    name = "infrastructure"
  }
}

resource "kubernetes_namespace" "devops" {
  metadata {
    name = "devops"
  }
}
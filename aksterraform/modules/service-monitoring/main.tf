resource "helm_release" "monitoring-prometheus" {
  name  = "prometheus"
  namespace = var.namespace
  chart = "./prometheus-15.18.0.tgz"

  set {
    name  = "alertmanager.persistentVolume.storageClass"
    value = var.storage_class_name
  }

  set {
    name  = "server.persistentVolume.storageClass"
    value = var.storage_class_name
  }

  values = [
    file("${path.module}/values-prometheus.yaml")
  ]
}

resource "helm_release" "monitoring-grafana" {
  name  = "grafana"
  namespace = var.namespace
  chart = "./grafana-6.50.7.tgz"
  values = [
    file("${path.module}/values-grafana.yaml")
  ]
}

resource "helm_release" "monitoring-prometheus-ingress" {
  name  = "monitoring-grafana-ingress"
  namespace = var.namespace
  chart = "${path.module}/monitoring-ingress"
  force_update = "true"

  set {
    name  = "ingress_class"
	value = var.ingress_class
  }
  
  set {
    name  = "http_application_routing_zone_name"
	value = var.http_application_routing_zone_name
  }
}
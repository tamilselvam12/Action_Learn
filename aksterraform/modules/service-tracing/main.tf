resource "helm_release" "tracing-jaeger" {
  name  = "tracing"
  namespace = var.namespace
  chart = "./jaeger-operator-2.18.4.tgz"

  values = [
    file("${path.module}/values-jaeger.yaml")
  ]
}

resource "helm_release" "tracing-jaeger-ingress" {
  name  = "tracing-jaeger-ingress"
  namespace = var.namespace
  chart = "${path.module}/tracing-ingress"
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
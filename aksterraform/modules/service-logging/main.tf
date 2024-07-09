resource "helm_release" "logging-elasticsearch" {
  name = "logging-elasticsearch"
  namespace = var.namespace
  chart = "https://helm.elastic.co/helm/elasticsearch/elasticsearch-8.5.1.tgz"

  values = [
    file("${path.module}/values-elasticsearch.yaml")
  ]

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "masterService"
    value = "logging-elasticsearch"
  }

  set {
    name  = "volumeClaimTemplate.storageClassName"
    value = var.storage_class_name
  }
}

resource "helm_release" "logging-fluend" {
  name  = "logging-fluend"
  namespace = var.namespace
  chart = "${path.module}/fluentd"

  set {
    name  = "cloud_provider"
	value = var.cloud_provider
  }

  set {
    name  = "namespace"
	value = var.namespace
  }
}

resource "helm_release" "logging-kibana" {
  name  = "logging-kibana"
  namespace = var.namespace
  chart = "https://helm.elastic.co/helm/kibana/kibana-8.5.1.tgz"
  timeout = 360

  set {
    name  = "elasticsearchHosts"
    value = "http://logging-elasticsearch:9200"
  }
}

resource "helm_release" "logging-kibana-ingress" {
  name  = "logging-kibana-ingress"
  namespace = var.namespace
  chart = "${path.module}/kibana-ingress"
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
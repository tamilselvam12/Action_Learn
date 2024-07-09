locals {
  container_registry_host = "TODO"
  container_registry_username = "TODO"
  container_registry_password = "TODO"
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.43.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "1.2.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.0.2"
    }	
  }
}

/////////////////////////////////
// Provider configuration
/////////////////////////////////
provider "azurerm" {
  skip_provider_registration = "true"
  features {}
  tenant_id = var.tenant_id
}

provider "azuread" {
  tenant_id = var.tenant_id_active_directory
}

	
provider "kubernetes" {
  host = file("./cfg_kubernetes_host")
  client_key = file("./cfg_kubernetes_client_key.pem")
  client_certificate = file("./cfg_kubernetes_certificate.pem")
  cluster_ca_certificate = file("./cfg_kubernetes_ca_certificate.pem")
}

provider "helm" {
  kubernetes {
    host = file("./cfg_kubernetes_host")
    client_key = file("./cfg_kubernetes_client_key.pem")
    client_certificate = file("./cfg_kubernetes_certificate.pem")
    cluster_ca_certificate = file("./cfg_kubernetes_ca_certificate.pem")
  }
}

module "cluster-namespace" {
  source = "../modules/cluster-namespace"
}


// Persistent volumes (managed disk)
// commented out, it causes issues in case of resource group permission only
/*
module "cluster-persistentvolume" {
  source = "../modules/cluster-persistentvolume/azure"
  
  tenant_id = var.tenant_id
  resource_group_name = var.resource_group_name
  // resource_group_name = "mc_luw-devtest_luw_switzerlandnorth"
  location = var.location
}
*/

/////////////////////////////////
// shared services
/////////////////////////////////

module "service-ingress-controller" {
  source = "../modules/service-ingress-controller"
  depends_on = [module.cluster-namespace]
}

module "service-oauth-proxy" {
  source = "../modules/service-oauth-proxy/azure-ad"

  tenant_id = var.tenant_id
  tenant_id_active_directory = var.tenant_id_active_directory
  resource_group_name = var.resource_group_name
  location = var.location
  identifier_uris = var.identifier_uris
  azuread_application_name = var.azuread_application_name
  ingress_hostname_prefix = var.ingress_hostname_prefix
  http_application_routing_zone_name = file("./cfg_kubernetes_routing_zone_name")
  depends_on = [module.cluster-namespace]
}

module "service-monitoring" {
  source = "../../modules/service-monitoring"

  http_application_routing_zone_name = file("./cfg_kubernetes_routing_zone_name")
  depends_on = [module.cluster-namespace]
}

module "service-logging" {
  source = "../modules/service-logging"

  http_application_routing_zone_name = file("./cfg_kubernetes_routing_zone_name")
  depends_on = [module.cluster-namespace]
}

module "service-tracing" {
  source = "../modules/service-tracing"

  http_application_routing_zone_name = file("./cfg_kubernetes_routing_zone_name")
  depends_on = [module.cluster-namespace]
}

module "service-keycloak" {
  source = "../modules/service-keycloak"

  http_application_routing_zone_name = file("./cfg_kubernetes_routing_zone_name")
  depends_on = [module.cluster-namespace]
}


/////////////////////////////////
// ci-cd tools
/////////////////////////////////
module "cicd-jenkins-image" {
  source = "../modules/cicd-jenkins-image"

  registry_host = local.container_registry_host
  registry_username = local.container_registry_username
  registry_password = local.container_registry_password
  depends_on = [module.cluster-namespace]
}

module "cicd-jenkins" {
  source = "../modules/cicd-jenkins"
  
  // empty to dynamically provision PV
  jenkins_disk_name = ""
  jenkins_disk_size_gb = "8"
  registry_host = local.container_registry_host
  registry_username = local.container_registry_username
  registry_password = local.container_registry_password
  http_application_routing_zone_name = file("./cfg_kubernetes_routing_zone_name")

  depends_on = [module.cicd-jenkins-image]
}

module "cicd-nexus" {
  source = "../modules/cicd-nexus"
  
  // empty to dynamically provision PV
  nexus_disk_name = ""
  depends_on = [module.cluster-namespace]
}
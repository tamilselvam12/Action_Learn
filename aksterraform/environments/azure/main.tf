terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.90.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "1.2.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
}


provider "azurerm" {
  skip_provider_registration = true
  features {}
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

provider "azuread" {
  tenant_id = var.tenant_id
}

provider "kubernetes" {
  host                   = module.cluster.kubernetes_host
  client_key             = base64decode(module.cluster.kubernetes_client_key_base64)
  client_certificate     = base64decode(module.cluster.kubernetes_client_certificate_base64)
  cluster_ca_certificate = base64decode(module.cluster.kubernetes_ca_certificate_base64)
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.kubernetes_host
    client_key             = base64decode(module.cluster.kubernetes_client_key_base64)
    client_certificate     = base64decode(module.cluster.kubernetes_client_certificate_base64)
    cluster_ca_certificate = base64decode(module.cluster.kubernetes_ca_certificate_base64)
  }
}

module "cluster" {
  source = "../../modules/cluster/azure"

  cluster_vm_size      = var.cluster_vm_size
  tenant_id            = var.tenant_id
  resource_group_name  = var.resource_group_name
  location             = var.location
  cluster_name_prefix  = var.cluster_name_prefix
}

module "cluster-namespace" {
  source = "../../modules/cluster-namespace"

  depends_on = [module.cluster]
}

module "service-iam-azure-ad" {
  source = "../../modules/service-iam/azure-ad"

  tenant_id                        = var.tenant_id
  tenant_id_active_directory       = var.tenant_id
  resource_group_name              = var.resource_group_name
  location                         = var.location
  identifier_uris                  = var.identifier_uris
  azuread_application_name         = var.azuread_application_name
  ingress_hostname_prefix          = var.ingress_hostname_prefix
  http_application_routing_zone_name = module.cluster.http_application_routing_zone_name
  depends_on                       = [module.cluster-namespace]
}

module "service-iam-azure-ad-dataengine" {
  source = "../../modules/service-iam-dataengine/azure-ad"

  tenant_id                        = var.tenant_id
  tenant_id_active_directory       = var.tenant_id
  resource_group_name              = var.resource_group_name
  location                         = var.location
  identifier_uris                  = var.identifier_uris_dataengine
  azuread_application_name         = var.azuread_application_name_dataengine
  ingress_hostname_prefix          = var.ingress_hostname_prefix
  http_application_routing_zone_name = module.cluster.http_application_routing_zone_name
  depends_on                       = [module.cluster-namespace]
}

module "service-iam-oauth2-proxy" {
  source = "../../modules/service-iam-oauth2-proxy/azure-ad"

  tenant_id_active_directory       = var.tenant_id
  azuread_application_id           = module.service-iam-azure-ad.azuread_application_id
  app_password                     = module.service-iam-azure-ad.app_password
  ingress_hostname_prefix          = var.ingress_hostname_prefix
  http_application_routing_zone_name = module.cluster.http_application_routing_zone_name
  depends_on                       = [module.cluster-namespace]
}

module "service-monitoring" {
  source = "../../modules/service-monitoring"

  storage_class_name               = var.storage_class_name
  http_application_routing_zone_name = module.cluster.http_application_routing_zone_name
  depends_on                       = [module.cluster-namespace]
}

module "service-tracing" {
  source = "../../modules/service-tracing"

  http_application_routing_zone_name = module.cluster.http_application_routing_zone_name
  depends_on                       = [module.cluster-namespace]
}

module "service-vault" {
  source = "../../modules/service-vault"
  
  storage_class_name  = var.storage_class_name  
  depends_on          = [module.cluster-namespace]
}

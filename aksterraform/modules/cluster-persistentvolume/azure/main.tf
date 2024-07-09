provider "azurerm" {
  version = "2.90.0"
  skip_provider_registration = "true"
  features {}
  tenant_id = var.tenant_id
}

provider "kubernetes" {
  version = "2.7.1"
  load_config_file = "false"
  
  host = fileexists("${path.module}/../../cfg_kubernetes_host") ? file("${path.module}/../../cfg_kubernetes_host") : var.kubernetes_host
  client_key = fileexists("${path.module}/../../cfg_kubernetes_client_key.pem") ? file("${path.module}/../../cfg_kubernetes_client_key.pem") : var.kubernetes_client_key
  client_certificate = fileexists("${path.module}/../../cfg_kubernetes_certificate.pem") ? file("${path.module}/../../cfg_kubernetes_certificate.pem") : var.kubernetes_client_certificate
  cluster_ca_certificate = fileexists("${path.module}/../../cfg_kubernetes_ca_certificate.pem") ? file("${path.module}/../../cfg_kubernetes_ca_certificate.pem") : var.kubernetes_ca_certificate
}

resource "azurerm_managed_disk" "nexus-disk" {
  name                 = var.nexus_disk_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = var.nexus_disk_source != "" ? "Copy" : "Empty"
  source_resource_id   = var.nexus_disk_source != "" ? var.nexus_disk_source : ""
  disk_size_gb         = var.nexus_disk_size_gb
}

resource "kubernetes_persistent_volume" "nexus-disk-pv" {

  metadata {
    name = var.nexus_disk_name
  }
  spec {
    storage_class_name = "default"
    capacity = {
      storage = "${var.nexus_disk_size_gb}Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = azurerm_managed_disk.nexus-disk.id
        disk_name     = var.nexus_disk_name
        kind          = "Managed"
      }
    }
  }
}

resource "azurerm_managed_disk" "jenkins-disk" {
  name                 = var.jenkins_disk_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = var.jenkins_disk_source != "" ? "Copy" : "Empty"
  source_resource_id   = var.jenkins_disk_source != "" ? var.jenkins_disk_source : ""
  disk_size_gb         = var.jenkins_disk_size_gb
}

resource "kubernetes_persistent_volume" "jenkins-disk-pv" {

  metadata {
    name = var.jenkins_disk_name
  }
  spec {
    storage_class_name = "default"
    capacity = {
      storage = "${var.jenkins_disk_size_gb}Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = azurerm_managed_disk.jenkins-disk.id
        disk_name     = var.jenkins_disk_name
        kind          = "Managed"
      }
    }
  }
  depends_on = [
    azurerm_managed_disk.jenkins-disk
  ]
}
data "azurerm_virtual_network" "base" {
  name                = "vnet-ibms2p-dev-eastus"
  resource_group_name = "rg-ibms2p-dev-network-eastus"
}


resource "azurerm_subnet" "aks" {
  name                 = "subnet-reckittaks-ci-poc-003"
  resource_group_name  = "rg-ibms2p-dev-network-eastus"
  address_prefixes     = ["10.51.9.112/24"]
  virtual_network_name = "vnet-ibms2p-dev-eastus"
}




// disabled since EFK is the default log analytics solution
/*
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.cluster_name_prefix}-log-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "log_analytics_solution" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics.id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}*/

resource "azurerm_kubernetes_cluster" "cluster" {
  name       = "${var.cluster_name_prefix}-cluster-poc-dev-001"
  location   = var.location
  dns_prefix = var.cluster_name_prefix

  resource_group_name = var.resource_group_name
  node_resource_group      = "${var.resource_group_name}-NODE"
  #kubernetes_version  = "1.25.11"
  kubernetes_version  = "1.27.9"

  default_node_pool {
    name       = var.cluster_name_prefix
    node_count = "1"
    vm_size    = var.cluster_vm_size
    vnet_subnet_id = azurerm_subnet.aks.id
	max_pods   = 100
  }

  addon_profile {
    http_application_routing {
      enabled = "true"
    }
    // disabled since EFK is the default log analytics solution
    //oms_agent {
    //  enabled = "true"
    //  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
    //}
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.kubernetes_tags
  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }
}


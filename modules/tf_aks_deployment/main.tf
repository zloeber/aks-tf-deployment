/* 
  AKS deployment
  Requires (already existing):
  - resource group 
  - vnet in the var.subnet_prefix network
  - A precreated SPN ID/Password with proper role assignment to the above resources

  Will create:
  - A private subnet in a /24 range
  - An autoscaling single node AKS cluster

 */
provider azurerm {
  features {}
}

data azurerm_resource_group target {
  name = var.resource_group
}

/* Subnet */
resource azurerm_subnet aks {
  name                 = "subnet_aks_cluster_${var.cluster_name}"
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet_name
  address_prefix       = "${var.subnet_prefix}${var.cluster_index}.0/24"

  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
}

/* Kubernetes Cluster Deployment */
resource azurerm_kubernetes_cluster aks {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.target.location
  dns_prefix          = var.cluster_name
  resource_group_name = var.resource_group
  node_resource_group = "${var.resource_group}-${var.cluster_name}-aks-managed"
  tags                = var.tags

  default_node_pool {
    name                = "workload"
    node_count          = var.node_count
    min_count           = var.min_nodes
    max_count           = var.max_nodes
    max_pods            = 30
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = "true"
    vm_size             = var.vm_size
    vnet_subnet_id      = azurerm_subnet.aks.id
    os_disk_size_gb     = 30
  }

  service_principal {
    client_id     = var.app_id
    client_secret = var.app_id_secret
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "Standard"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool,
      role_based_access_control,
      addon_profile,
    ]
  }
}

provider kubernetes {
  load_config_file       = false
  version                = "1.10.0"
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

output client_certificate {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
}

output client_key {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
}

output cluster_ca_certificate {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

output kube_config {
  value = azurerm_kubernetes_cluster.aks.kube_config.0
}

output host {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

output username {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.username
}

output password {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.password
}

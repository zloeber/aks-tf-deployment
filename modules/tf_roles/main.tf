/*
    All the roles required for an spn to have rights to create a managed aks cluster in a subscription.
*/

data azurerm_client_config current {}

data azurerm_subscription current {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

resource azurerm_role_definition az_billing_api {
  name        = "az_billing_api"
  scope       = data.azurerm_subscription.current.id
  description = "Role used to scrape billing information from the api."

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/vmSizes/read",
      "Microsoft.Resources/subscriptions/locations/read",
      "Microsoft.Resources/providers/read",
      "Microsoft.ContainerService/containerServices/read",
      "Microsoft.Commerce/RateCard/read",
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource azurerm_role_definition aks_cluster_compute_mgmt {
  name        = "aks_cluster_compute_mgmt"
  scope       = data.azurerm_subscription.current.id
  description = "Role used to create AKS clusters"

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resourcegroups/read",
      "Microsoft.ContainerService/managedClusters/write",
      "Microsoft.ContainerService/managedClusters/read",
      "Microsoft.ContainerService/managedClusters/agentPools/write",
      "Microsoft.ContainerService/managedClusters/agentPools/read",
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource azurerm_role_definition aks_cluster_delete_mgmt {
  name        = "aks_cluster_delete_mgmt"
  scope       = data.azurerm_subscription.current.id
  description = "Role used to delete AKS clusters"

  permissions {
    actions = [
      "Microsoft.ContainerService/managedClusters/delete"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource azurerm_role_definition aks_network_join {
  name        = "aks_network_join"
  scope       = data.azurerm_subscription.current.id
  description = "Can Join and AKS Cluster to a given vnet/subnet"

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resourcegroups/read",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource azurerm_role_definition resource_group_deployment_write {
  name        = "resource_group_deployment_write"
  scope       = data.azurerm_subscription.current.id
  description = "Can write deployments to resource groups"

  permissions {
    actions = [
      "Microsoft.Resources/deployments/write"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource azurerm_role_definition aks_log_analytics_join {
  name        = "aks_log_analytics_join"
  scope       = data.azurerm_subscription.current.id
  description = "Can join an AKS cluster to a log analytics workspace"

  permissions {
    actions = [
      "Microsoft.OperationalInsights/workspaces/sharedkeys/read",
      "Microsoft.OperationsManagement/solutions/write"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}
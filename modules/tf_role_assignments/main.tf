variable id {
  description = "Object ID of SPN to grant role access for aks creation"
}
variable resource_group {
  description = "resource group to scope role access"
}

provider azurerm {
  features {}
}

/* Provide spn access to create clusters in a resource group */
data azurerm_resource_group managed {
  name = var.resource_group
}
resource azurerm_role_assignment aks_cluster_compute_mgmt {
  scope                = data.azurerm_resource_group.managed.id
  role_definition_name = "aks_cluster_compute_mgmt"
  principal_id         = var.id
}
resource azurerm_role_assignment aks_cluster_delete_mgmt {
  scope                = data.azurerm_resource_group.managed.id
  role_definition_name = "aks_cluster_delete_mgmt"
  principal_id         = var.id
}
resource azurerm_role_assignment aks_network_join {
  scope                = data.azurerm_resource_group.managed.id
  role_definition_name = "aks_network_join"
  principal_id         = var.id
}
resource azurerm_role_assignment resource_group_deployment_write {
  scope                = data.azurerm_resource_group.managed.id
  role_definition_name = "resource_group_deployment_write"
  principal_id         = var.id
}
resource azurerm_role_assignment aks_log_analytics_join {
  scope                = data.azurerm_resource_group.managed.id
  role_definition_name = "aks_log_analytics_join"
  principal_id         = var.id
}

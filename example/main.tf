## Example of deploying a cluster

provider azurerm {
  features {}
}

provider azuread {}

resource azurerm_resource_group aks {
  name     = "myaksdeployment"
  location = "useast2"
  tags = {
    ORG = "MyOrg"
  }
}

resource azurerm_virtual_network aks_vnet {
  name                = "aks_vnet"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  address_space       = ["10.0.0.0/8"]
}

module aks_spn {
  source = "../modules/tf_spn"
  name   = "myaksspn"
}

module aks_roles {
  source = "../modules/tf_roles"
}

module aks_role_assignment {
  source         = "../modules/tf_role_assignments"
  id             = module.aks_spn.id
  resource_group = azurerm_resource_group.aks.name
}

module mycluster {
  source             = "../modules/tf_aks_deployment"
  cluster_index      = 1
  cluster_name       = "akscluster1"
  vm_size            = "Standard_D8s_v3"
  resource_group     = azurerm_resource_group.aks.name
  vnet_name          = azurerm_virtual_network.aks_vnet.name
  subnet_prefix      = "10.10."
  node_count         = 1
  min_nodes          = 1
  max_nodes          = 3
  app_id             = module.aks_spn.app_id
  app_id_secret      = module.aks_spn.secret
  namespace          = "app-namespace"           # your deployment namespace
  container_registry = "someregistry.azurecr.io" # Your container registry
  image              = "someimage"               # Your image
  image_tag          = "latest"                  # should NOT be latest (latest is the devil)

  tags = {
    ORG = "MyOrg"
  }
}

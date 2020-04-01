## Example of deploying a cluster with some secrets stored in keyvault.

provider azurerm {
  features {}
}

data azurerm_key_vault secretstore {
  name                = "myvaultname"
  resource_group_name = "vault_resource_group"
}
data azurerm_key_vault_secret app_id {
  name         = "SPNAPPID"
  key_vault_id = data.azurerm_key_vault.secretstore.id
}
data azurerm_key_vault_secret app_id_secret {
  name         = "SPNSECRET"
  key_vault_id = data.azurerm_key_vault.secretstore.id
}
data azurerm_key_vault_secret storage_account {
  name         = "STORAGEACCOUNTNAME"
  key_vault_id = data.azurerm_key_vault.secretstore.id
}
data azurerm_key_vault_secret storage_account_key {
  name         = "STORAGEACCOUNTKEY"
  key_vault_id = data.azurerm_key_vault.secretstore.id
}

module mycluster {
  source                 = "git::ssh://git@github.com/zloeber/aks_tf_deployment"
  cluster_index          = 1
  cluster_name           = "akscluster1"
  vm_size                = "Standard_D8s_v3"
  resource_group         = "deployment_resource_group"
  vnet_name              = "my_precreated_vnet"
  subnet_prefix          = "10.10."
  node_count             = 1
  min_nodes              = 1
  max_nodes              = 3
  app_id                 = data.azurerm_key_vault_secret.app_id.value
  app_id_secret          = data.azurerm_key_vault_secret.app_id_secret.value
  namespace              = "app-namespace" # your deployment namespace
  container_registry     = "someregistry.azurecr.io" # Your container registry
  image                  = "someimage" # Your image
  image_tag              = "latest" # should NOT be latest (latest is the devil)
  storage_account        = data.azurerm_key_vault_secret.storage_account.value
  storage_account_key    = data.azurerm_key_vault_secret.storage_account_key.value
  tags = {
    ORG     = "MyOrg"
  }
}

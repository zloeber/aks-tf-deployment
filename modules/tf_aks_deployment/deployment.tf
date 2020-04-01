data azurerm_client_config current {}

resource kubernetes_namespace deployment {
  metadata {
    name = var.namespace
  }
}

// Example Secrets to expose as env vars in deployment
resource kubernetes_secret appsecrets {
  metadata {
    name      = "appsecrets"
    namespace = kubernetes_namespace.deployment.metadata.0.name
  }
  type = "Opaque"
  data = {
    AZURE_ACCOUNT_KEY     = var.storage_account_key
    AZURE_CLIENT_ID       = var.app_id
    AZURE_CLIENT_SECRET   = var.app_id_secret
    AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
    AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
  }
}

// Example configmap settings to expose as env vars in deployment
resource kubernetes_config_map settings {
  metadata {
    name      = "appconfig"
    namespace = kubernetes_namespace.deployment.metadata.0.name
  }
  data = {
    SOMEPATH = "/root/why/is/this/parameterized"
    APPNAMESPACE = kubernetes_namespace.deployment.metadata.0.name
    CLOUDSERVICE = "Azure"
    STORAGEACCOUNTNAME = var.storage_account
    APPNAME = var.kubernetes_app_name
  }
}

resource kubernetes_deployment app {
  metadata {
    name      = var.kubernetes_app_name
    namespace = kubernetes_namespace.deployment.metadata.0.name
    labels = {
      app = var.kubernetes_app_name
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.kubernetes_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.kubernetes_app_name
        }
      }

      spec {
        container {
          name    = var.kubernetes_app_name
          image   = "${var.container_registry}/${var.image}:${var.image_tag}"
          command = var.container_command
          env_from {
            config_map_ref {
              name = kubernetes_config_map.settings.metadata.0.name
            }
          }
          env {
            name = "AZURE_CLIENT_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.appsecrets.metadata.0.name
                key  = "AZURE_CLIENT_SECRET"
              }
            }
          }
          env {
            name = "AZURE_CLIENT_ID"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.appsecrets.metadata.0.name
                key  = "AZURE_CLIENT_ID"
              }
            }
          }
          env {
            name = "AZURE_ACCOUNT_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.appsecrets.metadata.0.name
                key  = "AZURE_ACCOUNT_KEY"
              }
            }
          }
          env {
            name = "AZURE_SUBSCRIPTION_ID"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.appsecrets.metadata.0.name
                key  = "AZURE_SUBSCRIPTION_ID"
              }
            }
          }
          env {
            name = "AZURE_TENANT_ID"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.appsecrets.metadata.0.name
                key  = "AZURE_TENANT_ID"
              }
            }
          }

          resources {
            requests {
              memory = var.kubernetes_pod_memory
            }
          }

          termination_message_path = "/dev/termination-log"
          image_pull_policy        = "Always"
        }

        restart_policy                   = "Always"
        termination_grace_period_seconds = 30
        dns_policy                       = "ClusterFirst"
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "1"
        max_surge       = "1"
      }
    }
    revision_history_limit = 10
  }
}

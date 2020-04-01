variable cluster_index {
  type        = string
  default     = "1"
  description = "Index number for the cluster to be created (used as the subnet network as well)"
}
variable cluster_name {
  type        = string
  description = "Cluster name to be created"
}
variable vm_size {
  type        = string
  default     = "Standard_D8s_v3"
  description = "Node instance size"
}
variable resource_group {
  type        = string
  description = "cluster resource group name"
}
variable vnet_name {
  type        = string
  description = "virtual network name (should already exist)"
}
variable subnet_prefix {
  type        = string
  default     = "10.10."
  description = "prefix of subnet to create and use (will be combined with the cluster_index in a /24 network)"
}
variable node_count {
  default     = 1
  description = "starting node count"
}
variable min_nodes {
  default     = 1
  description = "minimum number of nodes"
}
variable max_nodes {
  default     = 8
  description = "maximum number of nodes"
}
// SPN Application ID and secret for cluster identity
variable app_id {}
variable app_id_secret {}

// Deployment information for application into your cluster
variable namespace {}
variable container_registry {}
variable image {}
variable image_tag {}
variable container_command {
  default = ["bash"]
}
variable kubernetes_app_name {
  default = "app-deployment"
}
variable kubernetes_pod_memory {
  default = "2Gi"
}
variable tags {
  type = map(string)
  default = {}
}

## Additional variables (used as an example)
variable storage_account {}
variable storage_account_key {}

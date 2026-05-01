output "aks_cluster_id" {
  description = "AKS cluster resource ID"
  value       = azurerm_kubernetes_cluster.aks_ea_vervea_cluster.id
}

output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.aks_ea_vervea_cluster.name
}

output "aks_cluster_endpoint" {
  description = "AKS cluster API endpoint"
  value       = azurerm_kubernetes_cluster.aks_ea_vervea_cluster.kube_config[0].host
  sensitive   = true
}

output "kube_config" {
  description = "Kubernetes configuration for kubectl"
  value       = azurerm_kubernetes_cluster.aks_ea_vervea_cluster.kube_config_raw
  sensitive   = true
}

output "client_certificate" {
  description = "Client certificate for Kubernetes authentication"
  value       = azurerm_kubernetes_cluster.aks_ea_vervea_cluster.kube_config[0].client_certificate
  sensitive   = true
}

output "resource_group_names" {
  description = "Names of created resource groups"
  value = {
    kronos_rg   = azurerm_resource_group.rg_ea_kronos.name
    network_rg  = azurerm_resource_group.rg_ea_vervea_network.name
    cluster_rg  = azurerm_resource_group.rg_ea_vervea_cluster.name
  }
}

output "vnet_id" {
  description = "Virtual Network resource ID"
  value       = azurerm_virtual_network.vnet_ea_vervea.id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = azurerm_virtual_network.vnet_ea_vervea.name
}

output "subnet_id" {
  description = "Node subnet resource ID"
  value       = azurerm_subnet.subnet_ea_vervea_nodes.id
}

output "aks_node_pool_name" {
  description = "Default AKS node pool name"
  value       = azurerm_kubernetes_cluster.aks_ea_vervea_cluster.default_node_pool[0].name
}

output "aks_managed_identity_principal_id" {
  description = "Principal ID of AKS cluster's managed identity"
  value       = azurerm_kubernetes_cluster.aks_ea_vervea_cluster.identity[0].principal_id
}

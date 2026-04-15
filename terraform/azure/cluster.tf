resource "azurerm_kubernetes_cluster" "aks_ea_vervea_cluster" {
  name                = "aks-ea-vervea-cluster"
  location            = azurerm_resource_group.rg_ea_vervea_cluster.location
  resource_group_name = azurerm_resource_group.rg_ea_vervea_cluster.name
  dns_prefix          = "aks-ea-vervea-cluster"
  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.1.10"
    service_cidr   = "10.0.1.0/24"
  }
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2ls_v2"
    vnet_subnet_id = azurerm_subnet.subnet_ea_vervea_nodes.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_ea_vervea_cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_ea_vervea_cluster.kube_config_raw

  sensitive = true
}
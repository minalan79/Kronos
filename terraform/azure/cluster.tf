resource "azurerm_kubernetes_cluster" "aks_ea_vervea_cluster" {
  name                = local.resource_naming.aks_cluster
  location            = azurerm_resource_group.rg_ea_vervea_cluster.location
  resource_group_name = azurerm_resource_group.rg_ea_vervea_cluster.name
  dns_prefix          = var.aks_dns_prefix
  network_profile {
    network_plugin = "azure"
    dns_service_ip = var.aks_dns_service_ip
    service_cidr   = var.aks_service_cidr
  }
  default_node_pool {
    name           = "default"
    node_count     = var.aks_node_count
    vm_size        = var.aks_vm_size
    vnet_subnet_id = azurerm_subnet.subnet_ea_vervea_nodes.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}
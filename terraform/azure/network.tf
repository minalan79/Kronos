resource "azurerm_virtual_network" "vnet_ea_vervea" {
  name                = "vnet-ea-network"
  location            = azurerm_resource_group.rg_ea_vervea_network.location
  resource_group_name = azurerm_resource_group.rg_ea_vervea_network.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_watcher" "nw_ea_vervea" {
  name                = "nw-ea-watcher"
  location            = azurerm_resource_group.rg_ea_vervea_network.location
  resource_group_name = azurerm_resource_group.rg_ea_vervea_network.name
}

resource "azurerm_subnet" "subnet_ea_vervea_nodes" {
  name                 = "subnet-ea-vervea-nodes"
  resource_group_name  = azurerm_resource_group.rg_ea_vervea_network.name
  virtual_network_name = azurerm_virtual_network.vnet_ea_vervea.name
  address_prefixes     = ["10.0.2.0/24"]
}
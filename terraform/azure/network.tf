resource "azurerm_virtual_network" "vnet_ea_vervea" {
  name                = local.resource_naming.vnet
  location            = azurerm_resource_group.rg_ea_vervea_network.location
  resource_group_name = azurerm_resource_group.rg_ea_vervea_network.name
  address_space       = var.vnet_address_space
  tags                = local.common_tags
}

resource "azurerm_network_watcher" "nw_ea_vervea" {
  name                = local.resource_naming.nw_watcher
  location            = azurerm_resource_group.rg_ea_vervea_network.location
  resource_group_name = azurerm_resource_group.rg_ea_vervea_network.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "subnet_ea_vervea_nodes" {
  name                 = local.resource_naming.subnet
  resource_group_name  = azurerm_resource_group.rg_ea_vervea_network.name
  virtual_network_name = azurerm_virtual_network.vnet_ea_vervea.name
  address_prefixes     = var.node_subnet_address_prefixes
}
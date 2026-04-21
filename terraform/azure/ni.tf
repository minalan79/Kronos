resource "azurerm_network_interface" "ni_ea_kronos" {
  name                = "ni-ea-kronos"
  location            = azurerm_resource_group.rg_ea_kronos.location
  resource_group_name = azurerm_resource_group.rg_ea_kronos

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_ea_vervea_nodes.id
    private_ip_address_allocation = "Dynamic"
  }
}
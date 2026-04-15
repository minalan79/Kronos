resource "azurerm_resource_group" "rg_ea_kronos" {
  name     = "rg-ea-kronos"
  location = "East Asia"
}

resource "azurerm_resource_group" "rg_ea_vervea_network" {
  name     = "rg-ea-vervea-network"
  location = "East Asia"
}

resource "azurerm_resource_group" "rg_ea_vervea_cluster" {
  name     = "rg-ea-vervea-cluster"
  location = "East Asia"
}
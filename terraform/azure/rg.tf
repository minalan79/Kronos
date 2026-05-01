resource "azurerm_resource_group" "rg_ea_kronos" {
  name     = local.resource_naming.rg_kronos
  location = var.azure_region
  tags     = local.common_tags
}

resource "azurerm_resource_group" "rg_ea_vervea_network" {
  name     = local.resource_naming.rg_network
  location = var.azure_region
  tags     = local.common_tags
}

resource "azurerm_resource_group" "rg_ea_vervea_cluster" {
  name     = local.resource_naming.rg_cluster
  location = var.azure_region
  tags     = local.common_tags
}
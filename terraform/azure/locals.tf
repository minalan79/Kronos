locals {
  name_suffix = "${var.organization}-${substr(var.azure_region, 0, 2)}"
  
  resource_naming = {
    rg_kronos   = "rg-${local.name_suffix}-${var.project_name}"
    rg_network  = "rg-${local.name_suffix}-${var.organization}-network"
    rg_cluster  = "rg-${local.name_suffix}-${var.organization}-cluster"
    vnet        = "vnet-${local.name_suffix}-network"
    nw_watcher  = "nw-${local.name_suffix}-watcher"
    subnet      = "subnet-${local.name_suffix}-${var.organization}-nodes"
    aks_cluster = "aks-${local.name_suffix}-${var.organization}-cluster"
  }

  common_tags = merge(
    var.common_tags,
    {
      CreatedDate = timestamp()
      Region      = var.azure_region
    }
  )
}

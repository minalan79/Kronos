resource "azurerm_linux_virtual_machine" "vm_ea_kronos" {
    name = "vm-ea-kronos"
    resource_group_name = azurerm_resource_group.rg_ea_kronos.id
    location = "East Asia"
    os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    }
    network_interface_ids = [ azurerm_network_interface.ni_ea_kronos.id ]
    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
    }
    size = "Standard_F2"
}
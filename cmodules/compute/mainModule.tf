resource "azurerm_network_interface" "compute" {
  name                = "${var.vm-name}-nic"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "compute" {
  name                = "${var.vm-name}-nsg"
  location            = var.location
  resource_group_name = var.rg
}
resource "azurerm_windows_virtual_machine" "compute" {
  name                       = "${var.vm-name}-vm01"
  resource_group_name        = var.rg
  location                   = var.location
  size                       = "Standard_B2s"
  admin_username             = var.admin_user
  admin_password             = var.admin_pass
  network_interface_ids      = [azurerm_network_interface.compute.id]
  enable_automatic_updates   = true
  provision_vm_agent         = true
  allow_extension_operations = true
  os_disk {
    name                 = "${var.vm-name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
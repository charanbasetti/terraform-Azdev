/*rg jbox-rg
vm jbox-vm01
nic jbox-nic
nsg jbox-nsg*/

resource "azurerm_resource_group" "jbox-rg" {
  name     = "${var.env}-Jbox-rg"
  location = var.location-name
}

module "jbox-vm" {
  source     = "../cmodules/compute"
  vm-name    = "${var.env}-Jbox"
  rg         = azurerm_resource_group.jbox-rg.name
  location   = azurerm_resource_group.jbox-rg.location
  subnet_id  = module.fe-vnet.vnet_subnets[1]
  admin_user = var.admin_username
  admin_pass = data.azurerm_key_vault_secret.sec01.value
}
resource "azurerm_network_security_rule" "jbox-rg" {
  name                        = "rdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "${module.jbox-vm.vm_private_ip}/32"
  resource_group_name         = azurerm_resource_group.jbox-rg.name
  network_security_group_name = module.jbox-vm.nsg_name
}
resource "azurerm_network_interface_security_group_association" "jbox-rg" {
  network_interface_id      = module.jbox-vm.nic_id
  network_security_group_id = module.jbox-vm.nsg_id
}

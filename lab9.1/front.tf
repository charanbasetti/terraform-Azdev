#rg fe-rg
#pip pub-ip01
#fw  fw-01
#vnet fe-vnet
# Configure the Microsoft Azure Provider
#ResourceGroup

resource "azurerm_resource_group" "fe-rg" {
  name     = "${var.env}.Fe-rg"
  location = var.location-name
}
# Create a virtual network within the resource group
module "fe-vnet" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.fe-rg.name
  address_space       = "10.0.0.0/23"
  subnet_prefixes     = ["10.0.0.0/24", "10.0.1.0/24"]
  subnet_names        = ["AzureFirewallSubnet", "${var.env}.jbox-subnet"]
  tags                = {}
  depends_on = [azurerm_resource_group.fe-rg]
}
/*
resource "azurerm_virtual_network" "fe-rg" {
  name                = var.fe-vnet-name
  resource_group_name = azurerm_resource_group.fe-rg.name
  location            = azurerm_resource_group.fe-rg.location
  address_space       = ["10.0.0.0/23"]
}
#Subnets:
resource "azurerm_subnet" "fe-rg-01" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.0.0/24"]
}
resource "azurerm_subnet" "fe-rg-02" {
  name                 = var.jb-sub-name
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.1.0/24"]
}
*/
resource "azurerm_public_ip" "fe-rg" {
  name                = "${var.env}.Pub-ip01"
  resource_group_name = azurerm_resource_group.fe-rg.name
  location            = azurerm_resource_group.fe-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

}
resource "azurerm_firewall" "fe-rg" {
  name                = "${var.env}.FW-01"
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name

  ip_configuration {
    name                 = "fwip-config"
    subnet_id            = module.fe-vnet.vnet_subnets[0]
    public_ip_address_id = azurerm_public_ip.fe-rg.id
  }
}
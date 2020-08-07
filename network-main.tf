# Create a RG for victim network

resource "azurerm_resource_group" "victim_rg" {
  name      = var.victim_company_rg_name
  location  = var.location
  
  tags      = {
    application = var.victim_company
    environment = var.environment
  }
}

# Create the victim network VNET

resource "azurerm_virtual_network" "victim_vnet" {
  name                = var.victim_company_vnet
  address_space       = [var.victim_vnet_cidr]
  resource_group_name = azurerm_resource_group.victim_rg.name
  location            = azurerm_resource_group.victim_rg.location
  
  tags                = {
    application       = var.victim_company
    environment       = var.environment
  }
}

# Create a victim subnet for Network

resource "azurerm_subnet" "victim_subnet" {
  name                 = var.victim_company_subnet
  address_prefix       = var.victim_subnet_cidr
  virtual_network_name = azurerm_virtual_network.victim_vnet.name
  resource_group_name  = azurerm_resource_group.victim_rg.name
}

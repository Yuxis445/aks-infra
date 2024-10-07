locals {
  env = "${var.environment}" == "" ? "" : "${var.environment}-"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${local.env}security-group"
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.env}network"
  address_space       = ["${var.network_cidr}"]
  location            = var.rg_location
  resource_group_name = var.rg_name

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "${local.env}subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-${local.env}aks"
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Static"
}
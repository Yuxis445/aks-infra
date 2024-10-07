output "vnet_subnet_prefix" {
  value = azurerm_subnet.subnet.address_prefixes[0]
}

output "vnet_subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "pip_id" {
  value = azurerm_public_ip.pip.id
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}
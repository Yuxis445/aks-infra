
resource "azurerm_user_assigned_identity" "identity" {
  location            = var.location
  name                = "identity-${var.environment}"
  resource_group_name = var.rg
}
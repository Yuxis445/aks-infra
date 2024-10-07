resource "azurerm_resource_group" "my-rg" {
  name     = "resource-test"
  location = var.region
}

module "network" {

  source = "../../modules/networks"

  rg_name = azurerm_resource_group.my-rg.name
  rg_location = azurerm_resource_group.my-rg.location
  region = var.region
  environment = var.environment
  network_cidr = var.network_cidr

  depends_on = [ azurerm_resource_group.my-rg ]
}

module "identity" {
  source = "../../modules/identity"
  rg = azurerm_resource_group.my-rg.name
  location = azurerm_resource_group.my-rg.location
  environment = var.environment
}

module "aks" {
  depends_on = [ module.network ]
  source = "../../modules/aks"
  rg_name = azurerm_resource_group.my-rg.name
  rg_location = azurerm_resource_group.my-rg.location
  environment = var.environment
  # service_cidr = module.network.vnet_subnet_prefix
  vnet_id = module.network.vnet_subnet_id
  pip_id = module.network.pip_id
  identity_id = module.identity.identity_id
}

module "argo" {
  source = "../../modules/argo_cd"
  enabled = module.aks.kube_config_raw != null ? 1 : 0

  kube_config = module.aks.kube_config_raw
  client_certificate = module.aks.client_certificate
  client_key = module.aks.client_key
  cluster_ca_certificate = module.aks.cluster_ca_certificate
  kubernetes_host = module.aks.kubernetes_host
}

module "postgresql" {
  source              = "../../modules/postgresql"
  name                = var.db_name
  resource_group_name = azurerm_resource_group.my-rg.name
  location            = azurerm_resource_group.my-rg.location
  admin_username      = var.db_admin_username
  admin_password      = var.db_admin_password
}

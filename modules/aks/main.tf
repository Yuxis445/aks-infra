locals {
  env = "${var.environment}" == "" ? "" : "${var.environment}-"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${local.env}aks"
  location            = var.rg_location
  resource_group_name = var.rg_name
  dns_prefix          = "testing-aks"
  
  
  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
    os_disk_type        = "Managed"
    zones = [ 1 ]
    vnet_subnet_id = var.vnet_id
    auto_scaling_enabled = false
    type = "VirtualMachineScaleSets"
  }
  node_resource_group = "${var.rg_name}-node"
  role_based_access_control_enabled = true

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr = "10.0.2.0/24"
    dns_service_ip     = "10.0.2.10"
    load_balancer_sku = "standard"
    outbound_type   = "loadBalancer"

    load_balancer_profile {
      outbound_ip_address_ids = [ var.pip_id ]
    }

  }

  tags = {
    environment = "Demo"
    Terraform = "True"
  }
}

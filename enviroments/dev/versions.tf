locals {
  kubeconfig_raw = module.aks.kube_config_raw
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.3.0, < 5.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.15.0, < 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.32.0, < 3.0.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = "2cda291c-24de-4ef3-9811-45243a5369c1"
}

provider "helm" {
  kubernetes {
    config_path = local.kubeconfig_raw
  }
}

provider "kubernetes" {
  config_path = local.kubeconfig_raw
}

provider "kubectl" {
  config_path = local.kubeconfig_raw
}
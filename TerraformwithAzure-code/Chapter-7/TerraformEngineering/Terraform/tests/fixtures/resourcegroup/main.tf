terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.53.0"
    }
  }

  
}

provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  features {}
}

module "app_resource_group" {
    source = "../../../modules/resourcegroup"
    resource_group_name = var.resource_group_name
    resource_group_location = var.resource_group_location
}
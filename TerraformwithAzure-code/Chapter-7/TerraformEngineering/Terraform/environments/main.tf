
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.53.0"
    }
  }



    backend "azurerm" {
    resource_group_name   = "Xxx"
    storage_account_name  = "xxx"
    container_name        = "xxx"
    key                   = "xxx"
    sas_token            = "xxx"
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
    source = "../modules/resourcegroup"
    resource_group_name = var.resource_group_name
    resource_group_location = var.resource_group_location
}



resource "azurerm_storage_account" storage_account {
  name                     = var.storage_account_name
  resource_group_name      = module.app_resource_group.resource_group_name
  location                 = module.app_resource_group.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version = "TLS1_2"
  
  tags = {
    environment = "staging"
  }
}





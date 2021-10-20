


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.53.0"
    }
  }

  required_version = "= 0.14.10"

  backend "azurerm" {
    resource_group_name   = "Xxx"
    storage_account_name  = "xxx"
    container_name        = "xxx"
    key                   = "xxx"
    sas_token            = "xxx"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  features {}
}


  client_secret   = var.client_secret
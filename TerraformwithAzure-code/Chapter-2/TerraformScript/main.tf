terraform {

    required_providers {
    azurerm = {
      version = "~> 2.51.0"
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
    features {}
}

variable resource_group_name {
    type = string
    description = "the name of resource group for containing resources"
}

variable resource_location {
    type = string
    description = "azure location for hosting resources"
}

variable storage_account_name {
    type = string
    description = "the name of Azure storage account"
}

resource "azurerm_resource_group" "myrg" {
  name     = var.resource_group_name
  location = var.resource_location
}

resource "azurerm_storage_account" "mystorage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.myrg.name
  location                 = azurerm_resource_group.myrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "test"
  }
}

output resource_group_details {
    value = azurerm_resource_group.myrg
}

output storage_account_details {
    value = azurerm_storage_account.mystorage
}

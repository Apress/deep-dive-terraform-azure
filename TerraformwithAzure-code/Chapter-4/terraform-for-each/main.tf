terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.53.0"
    }
  }

}

provider "azurerm" {
  features {}
}

variable resource_group_name { type=string }
variable resource_group_location { type=string }
variable storage_account_info { type=map }

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "storage_account" {
  for_each = var.storage_account_info
  name = each.key
  location            = each.value
  resource_group_name = azurerm_resource_group.resource_group.name
  account_replication_type = "LRS"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

  enable_https_traffic_only = true
}

output storage_account_location_eastus {
    value = azurerm_storage_account.storage_account["mapstoragename1"].name
}

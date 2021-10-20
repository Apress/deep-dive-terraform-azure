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
variable storage_account_name { type=string }
variable storage_account_eastus { type=bool }

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "storage_account_eastus" {
  count = var.storage_account_eastus ==  true ? 1 : 0
  name = var.storage_account_name
  location            = "eastus"
  resource_group_name = azurerm_resource_group.resource_group.name
  account_replication_type = "LRS"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

  enable_https_traffic_only = true
}

resource "azurerm_storage_account" "storage_account_westus" {
  count = var.storage_account_eastus == false ? 1 : 0
  name = var.storage_account_name
  location            = "westus"
  resource_group_name = azurerm_resource_group.resource_group.name
  account_replication_type = "LRS"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

  enable_https_traffic_only = true
}

output storage_account_id_westus {
    value = azurerm_storage_account.storage_account_westus[*].id
}

output storage_account_location_westus {
    value = azurerm_storage_account.storage_account_westus[*].location
}

output storage_account_id_eastus {
    value = azurerm_storage_account.storage_account_eastus[*].id
}

output storage_account_location_eastus {
    value = azurerm_storage_account.storage_account_eastus[*].location
}

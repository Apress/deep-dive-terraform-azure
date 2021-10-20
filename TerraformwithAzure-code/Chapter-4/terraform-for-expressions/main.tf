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

variable storage_account_info { type=map }



output storage_account_location_eastus {
    value = {for name, location in var.storage_account_info: lower(name) => upper(location)}
}


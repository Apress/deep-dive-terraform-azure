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

variable resource_group_name { type=list(string) }

output stringdsingleline {
    value = "%{ for val in var.resource_group_name } ${ val } %{ endfor }"
}

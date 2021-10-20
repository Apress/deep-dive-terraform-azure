terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.53.0"
    }
  }

  required_version = "~> 0.14"
}

provider "azurerm" {
  features {}
}

variable resource_group_name { type=list(string) }

output ifstringdirective {
    value = "%{ if var.resource_group_name == "simpletfexample" } name of resource group is ${ var.resource_group_name } %{else} improper resource group name %{ endif }"
    
}

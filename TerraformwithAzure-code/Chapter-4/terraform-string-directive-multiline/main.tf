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

output stringd {
    value = <<EOT
    %{ for val in var.resource_group_name }
    ${ val }
    %{ endfor }
    EOT
}

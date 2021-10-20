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

variable resource_group_name { type= string }
variable resource_group_location { type= string }

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_location

  provisioner "local-exec" {
    command = "echo ${azurerm_resource_group.resource_group.id}"
  }
}

resource "null_resource" mynullresource {
    provisioner "local-exec" {
      command  = "date"
      interpreter = ["bash", "-c"]
    }
  }

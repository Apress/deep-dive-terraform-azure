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
variable custom_tags { type=map }
variable app_service_plan_name { type=string }
variable app_service_plan_kind{ type=string }
variable app_service_plan_sku { type = map }
variable app_service_name{ type=string }
variable connection_strings { type = list(object(
    {
        name = string,
        type = string,
        value = string
    }
))}

locals {
    default_tags = {
        "department" : "finance",
        "owner" : "riteshmodi"
    }

    app_size = "B2"
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name = var.app_service_plan_name

  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  kind                = var.app_service_plan_kind
  reserved            = var.app_service_plan_kind == "Linux" ? true : false

  sku {
    capacity = lookup(var.app_service_plan_sku, "capacity", null)
    size     = lookup(var.app_service_plan_sku, "size", null)
    tier     = lookup(var.app_service_plan_sku, "tier", null)
  }

  tags = merge(local.default_tags, var.custom_tags)
}

resource "azurerm_app_service" "app_service" {
  name                = var.app_service_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }

  https_only              = true
}

output app_service_plan_identifier {
    value = azurerm_app_service_plan.app_service_plan.id
}

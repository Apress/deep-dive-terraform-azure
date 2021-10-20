variable rg_name { type = string }
variable location {type= string }
variable client_id {type= string }
variable subscription_id {type= string }
variable tenant_id {type= string }
variable client_secret {type= string }


provider "azurerm" {
    client_id = var.client_id
    client_secret = var.client_secret
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
    features {}
}

resource "azurerm_resource_group" "rgdemo" {
  name     = var.rg_name
  location = var.location
}

output rg_identifier {
    value = azurerm_resource_group.rgdemo.name
}

output rg_id {
    value = azurerm_resource_group.rgdemo.id
}

variable rg_name { type = string }
variable location {type= string }


provider "azurerm" {
        client_id = "3b1d896c-00c1-4a2a-ac58-8c047472f380"
        client_secret = "tNRAC2GW~EF4-7tcFOX62OOC8WyS~35_Ce"
        subscription_id = "9755ffce-e94b-4332-9be8-1ade15e78909"
        tenant_id = "771f1cf4-b1ac-4f2e-ad21-de39ea201e7e"
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

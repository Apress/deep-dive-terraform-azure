terraform {
    backend "azurerm" {
        resource_group_name  = "remotestoragerg"
        storage_account_name = "remotestatestorage"
        container_name       = "statefiles"
        key                  = "prod.terraform.tfstate"
        
    }
}

provider "azurerm" {
    version = "~>2.0"

    features {}
}

resource azurerm_resource_group rgname {
    name = "testrgforstate"
    location = "west europe"
}

output rgoutput {
    value = azurerm_resource_group.rgname
}

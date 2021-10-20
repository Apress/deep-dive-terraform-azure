terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 2.41"
        }
    }
}

provider azurerm {
    features {}
}

resource azurerm_resource_group rg {
    name= "providertestrg"
    location = "west europe"
}

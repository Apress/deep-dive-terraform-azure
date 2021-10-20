terraform {
    required_providers {
        azurerm = {
            source  = "registry.terraform.io/hashicorp/azurerm"
            version = "~>2.36, ~>2.40"
            
        }
        someotherprovider = {
            source  = "registry.terraform.io/hashicorp/azurerm"
            version = "~>2.36, ~>2.40"
            
        }
    }
}

provider azurerm {
    features {}
}

provider someotherprovider  {
    features {}
}


resource azurerm_resource_group rg {
    name= "providertestrg"
    location = "west europe"
    provider = someotherprovider
}

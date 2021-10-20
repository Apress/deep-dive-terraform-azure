
terraform {
    required_version = "0.13.3"
    required_providers {
        azurerm = {
            source  = "registry.terraform.io/hashicorp/azurerm"
            version = "~>2.36, ~>2.40"
            
        }
    }
}

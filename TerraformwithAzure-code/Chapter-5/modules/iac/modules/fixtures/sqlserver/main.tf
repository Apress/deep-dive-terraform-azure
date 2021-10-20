
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.51.0"
    }
  }
}

provider "azurerm" {
    features {}
}


module "sql_server" {
    source = "../../resources/sqlserver"
    location = var.location
    whitelist_ip_addresses = var.whitelist_ip_addresses
    sql_server_name = var.sql_server_name
    admin_username = var.admin_username
    admin_password = var.admin_password
    database_name = var.database_name
    sql_tags = var.sql_tags
    resource_group_name = var.resourceGroupName
}
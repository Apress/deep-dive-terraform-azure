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


data "azurerm_client_config" "current" {}
module "resourceGroup" {
    source  = "../../modules/resources/groups"
    resourceGroupName = var.resourceGroupName
    resourceGroupLocation = var.resourceGroupLocation
    resourceGroupTags = var.resourceGroupTags

}

module "data_sql_resource" {
    source  = "../../modules/resources/sqlserver"
    resource_group_name = module.resourceGroup.resourceGroupName
    location = var.resourceGroupLocation
    whitelist_ip_addresses = var.whitelist_ip_addresses
    sql_server_name = var.sql_server_name
    admin_username = var.admin_username
    admin_password = var.admin_password
    database_name = var.database_name
    sql_tags = var.sql_tags

}
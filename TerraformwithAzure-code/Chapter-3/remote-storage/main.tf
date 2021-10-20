
variable rgname { type=  string}
variable location { type=  string}


provider "azurerm" {
    version = "~>2.0"
    features {}
}


resource "azurerm_resource_group" "remotestaterg" {
  name     = var.rgname
  location = var.location
}


resource "azurerm_storage_account" "remotestatestorage" {
  name                     = "remotestatestorage"
  resource_group_name      = azurerm_resource_group.remotestaterg.name
  location                 = azurerm_resource_group.remotestaterg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}


resource "azurerm_storage_container" "remotestate-container" {
  name                  = "statefiles"
  storage_account_name  = azurerm_storage_account.remotestatestorage.name
  container_access_type = "private"
}

data "azurerm_storage_account_sas" "storage-sas" {
  connection_string = azurerm_storage_account.remotestatestorage.primary_connection_string
  https_only        = true

  start  = "2020-12-25"
  expiry = "2021-10-20"

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

    resource_types {
    service   = true
    container = true
    object    = true
  }

   permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
  }

}


output "sas_container_query_string" {
  value = data.azurerm_storage_account_blob_container_sas.container-sas.sas
}

output "sas_storage_query_string" {
  value = data.azurerm_storage_account_sas.storage-sas.sas
}


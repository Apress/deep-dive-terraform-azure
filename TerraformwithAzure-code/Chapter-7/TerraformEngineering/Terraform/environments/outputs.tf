

output storage_blob_endpoint {
    value = azurerm_storage_account.storage_account.primary_blob_endpoint
    sensitive = true
}

output storage_connectionstring {
    value = azurerm_storage_account.storage_account.primary_connection_string
    sensitive = true
}

output storage_location {
    value = azurerm_storage_account.storage_account.location
}

output resource_group_location {
    value = module.app_resource_group.resource_group_location
}

output resource_group_id {
    value = module.app_resource_group.resource_group_id
}
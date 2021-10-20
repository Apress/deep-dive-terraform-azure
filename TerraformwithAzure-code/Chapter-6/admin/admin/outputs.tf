output subscription_data {
    value = data.azurerm_subscription.primary
    sensitive = true
}

output sp_data {
    value = data.azurerm_client_config.primary
    sensitive = true
}

output sas_token  {
    value = data.azurerm_storage_account_sas.state_container_sas_token.sas
    sensitive = true
}

output sp_auth  {
    value = azuread_service_principal.book_service_principle
    sensitive = true
}
output objectsids  {
    value = local.keyvault_policy_owners
    sensitive = true
}

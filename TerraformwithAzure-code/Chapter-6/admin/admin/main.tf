data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "primary" {
}

resource azurerm_resource_group common_resource_group {
    name = var.resource_group_name
    location = var.resource_group_location

    tags = var.all_tags
}

resource  azurerm_storage_account statestorage {
    name = var.storage_account_name
    location = azurerm_resource_group.common_resource_group.location
    resource_group_name =azurerm_resource_group.common_resource_group.name
    account_tier             = "Standard"
    account_replication_type = "GRS"
    enable_https_traffic_only  = true
    allow_blob_public_access  = false
    min_tls_version = "TLS1_2"
    tags  = var.all_tags
}

resource azurerm_storage_container statecontainer {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.statestorage.name
  container_access_type = "private"
}

data azurerm_storage_account_sas state_container_sas_token {
  connection_string = azurerm_storage_account.statestorage.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2021-03-21T00:00:00Z"
  expiry = "2021-09-21T00:00:00Z"

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


resource "azuread_application" "book_service_application" {
  display_name               = var.ad_application_name
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
  owners                     = [data.azurerm_client_config.primary.object_id]
}




resource "azuread_service_principal" "book_service_principle" {
  application_id               = azuread_application.book_service_application.application_id
  app_role_assignment_required = false

}

resource "azuread_service_principal_password" "book_service_principle_password" {
  service_principal_id = azuread_service_principal.book_service_principle.id
  description          = "My managed password"
  value                = var.ad_application_password
  end_date             = "2099-01-01T01:02:03Z"
}

resource "azurerm_role_assignment" "executor" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.primary.object_id
}

resource "azurerm_role_assignment" "book-service-principle-role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.book_service_principle.object_id
}


resource "azurerm_key_vault" "book_keyvault" {
  name = var.keyvault_name

  location            = azurerm_resource_group.common_resource_group.location
  resource_group_name = azurerm_resource_group.common_resource_group.name

  tenant_id = data.azurerm_client_config.primary.tenant_id

  sku_name = "standard"

  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = true

  tags = var.all_tags
}

resource "azurerm_key_vault_access_policy" "book_owner_access_policy" {
  count = length(local.keyvault_policy_owners )

  object_id    = local.keyvault_policy_owners["${count.index}"]
  tenant_id    = data.azurerm_client_config.primary.tenant_id
  key_vault_id = azurerm_key_vault.book_keyvault.id

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "Update",
    "Verify",
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]

  depends_on = [
    azurerm_role_assignment.book-service-principle-role,
    azuread_service_principal_password.book_service_principle_password,
    azuread_service_principal.book_service_principle
  ]
}

resource "azurerm_key_vault_secret" "sql-username" {
  for_each = var.keyvault_pairs

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.book_keyvault.id

    depends_on = [
    azurerm_role_assignment.book-service-principle-role,
    azuread_service_principal_password.book_service_principle_password,
    azuread_service_principal.book_service_principle,
    azurerm_key_vault_access_policy.book_owner_access_policy
  ]
}
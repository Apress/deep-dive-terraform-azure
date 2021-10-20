data "azurerm_key_vault" "bookkeyvault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}


data "azurerm_key_vault_secret" "sql_username_secret" {
  name         = var.administrator_login
  key_vault_id = data.azurerm_key_vault.bookkeyvault.id
}

data "azurerm_key_vault_secret" "sql_password_secret" {
  name         = var.administrator_password
  key_vault_id = data.azurerm_key_vault.bookkeyvault.id
}
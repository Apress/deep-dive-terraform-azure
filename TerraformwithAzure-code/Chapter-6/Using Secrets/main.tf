

resource azurerm_resource_group common_resource_group {
    name = var.resource_group_name
    location = var.resource_group_location

    tags = var.all_tags
}


resource "azurerm_sql_server" "book_sql_server" {
  name = var.sql_server_name

  location            = azurerm_resource_group.common_resource_group.location
  resource_group_name = azurerm_resource_group.common_resource_group.name

  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.sql_username_secret.value
  administrator_login_password = data.azurerm_key_vault_secret.sql_password_secret.value

  tags = var.all_tags
}

resource "azurerm_sql_firewall_rule" "book_sql_firewall_rule" {
  count = length(var.allowed_cidr_list)

  name                = "firewall-rule-${count.index}"
  resource_group_name = azurerm_resource_group.common_resource_group.name
  server_name         = azurerm_sql_server.book_sql_server.name

  start_ip_address = cidrhost(var.allowed_cidr_list[count.index], 0)
  end_ip_address   = cidrhost(var.allowed_cidr_list[count.index], -1)
}


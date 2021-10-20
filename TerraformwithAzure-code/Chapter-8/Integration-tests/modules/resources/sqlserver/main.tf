
resource "azurerm_sql_server" "sql_server" {
  name = var.sql_server_name

  location            = var.location
  resource_group_name = var.resource_group_name

  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  tags = var.sql_tags
}

resource "azurerm_sql_firewall_rule" "sql_firewall_rule" {
  count = length(var.whitelist_ip_addresses)

  name                = "iprule-${count.index}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql_server.name

  start_ip_address = cidrhost(var.whitelist_ip_addresses[count.index], 0)
  end_ip_address   = cidrhost(var.whitelist_ip_addresses[count.index], -1)
}

resource "azurerm_sql_database" "sql_database" {
  

  name                = var.database_name
  location            = var.location
  resource_group_name = var.resource_group_name

  server_name = azurerm_sql_server.sql_server.name
  collation   = "SQL_LATIN1_GENERAL_CP1_CI_AS"

  requested_service_objective_name = "S2"

  tags = var.sql_tags
}

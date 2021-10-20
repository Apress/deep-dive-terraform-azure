output "sql_server_id" {
  description = "Id of the SQL Server"
  value       = azurerm_sql_server.sql_server.id
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = azurerm_sql_server.sql_server.fully_qualified_domain_name
}

output "sql_databases_id" {
  description = "Id of the SQL Databases"
  value       = azurerm_sql_database.sql_database.name
}





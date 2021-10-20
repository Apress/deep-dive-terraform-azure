output "sql_server_id" {
  description = "Id of the SQL Server"
  value       = module.sql_server.sql_server_id
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = module.sql_server.sql_server_fqdn
}



output "sql_databases_id" {
  description = "Id of the SQL Databases"
  value       = module.sql_server.sql_databases_id
}




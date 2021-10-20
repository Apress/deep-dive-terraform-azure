

output "completeResourceGroup" {
    value = module.resourceGroup.completeResourceGroup
}

output "resourceGroupIdentifier" {
    value = module.resourceGroup.resourceGroupIdentifier
}

output "resourceGroupName" {
    value = module.resourceGroup.resourceGroupName
}

output "resourceGroupLocation" {
    value = module.resourceGroup.resourceGroupLocation
}

output "sql_server_id" {
  description = "Id of the SQL Server"
  value       = module.data_sql_resource.sql_server_id
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = module.data_sql_resource.sql_server_fqdn
}

output "sql_databases_id" {
  description = "Id of the SQL Databases"
  value       = module.data_sql_resource.sql_databases_id
}





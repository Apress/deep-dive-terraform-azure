variable "resource_group_name" {
  description = "name of resource group for hosting sql server and database"
  type = string
}

variable "location" {
  description = "Azure region for resource group and sql resources"
  type        = string
}


variable "whitelist_ip_addresses" {
  description = "whitelist ip address for sql server"
  type        = list(string)
  default     = ["0.0.0.0/32"]
}

variable "sql_server_name" {
  description = "sql server display and internal name"
  type        = string
}

variable "admin_username" {
  description = "admin username associated with sql server"
  type        = string
}

variable "admin_password" {
  description = "admin password associated with sql server"
  type        = string
}

variable "database_name" {
  description = "sql database display and internal name"
  type        = string
}


variable "sql_tags" {
  type = map(string)
}
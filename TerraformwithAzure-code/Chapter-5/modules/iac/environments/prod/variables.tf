
variable resourceGroupName { type= string}
variable resourceGroupLocation { type= string}

variable resourceGroupTags { type =  map(string)}




variable "sql_tags" {
    type = map(string)
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




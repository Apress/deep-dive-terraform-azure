variable resource_group_name  { type = string }
variable resource_group_location  { type = string }
variable all_tags  { type = map(string) }
variable sql_server_name  { type = string }
variable administrator_login  { type = string }
variable administrator_password  { type = string }
variable key_vault_name  { type = string }
variable key_vault_rg  { type = string }
variable client_id  { type = string }
variable subscription_id  { type = string }
variable client_secret  { type = string }
variable tenant_id  { type = string }
variable allowed_cidr_list { type = list(string) }


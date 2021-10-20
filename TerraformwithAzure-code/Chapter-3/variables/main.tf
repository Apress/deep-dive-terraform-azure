Variable resourceGroupName {
	Type= string
	Default = "dev-ecommerce-rg"
    Description = "This is used for naming the resource group related to ecommerce application in development environment"
}

variable rgname {
    type = string
    validation {
        condition = (length(var.rgname) <= 90 && length(var.rgname) > 2 && can(regex("[-\\w\\._\\(\\)]+", var.rgname)) )
        error_message = "Resource group name may only contain alphanumeric characters, dash, underscores, parentheses and periods."
    }
    sensitive = true    
}


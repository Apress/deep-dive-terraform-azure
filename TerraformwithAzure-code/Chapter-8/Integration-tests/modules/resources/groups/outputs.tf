

output "completeResourceGroup" {
    value = azurerm_resource_group.resourceGroup
}

output "resourceGroupIdentifier" {
    value = azurerm_resource_group.resourceGroup.id
}

output "resourceGroupName" {
    value = azurerm_resource_group.resourceGroup.name
}

output "resourceGroupTags" {
    value = azurerm_resource_group.resourceGroup.tags
}

output "resourceGroupLocation" {
    value = azurerm_resource_group.resourceGroup.location
}
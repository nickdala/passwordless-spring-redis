resource "azurecaf_name" "app_service_identity_name" {
  name          = var.environment_name
  resource_type = "azurerm_user_assigned_identity"
  suffixes      = [var.location, var.environment]
}

resource "azurerm_user_assigned_identity" "app_service_identity" {
  location            = azurerm_resource_group.resource_group.location
  name                = azurecaf_name.app_service_identity_name.result
  resource_group_name = azurerm_resource_group.resource_group.name
}

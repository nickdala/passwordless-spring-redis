resource "azurecaf_name" "cache" {
  random_length = "15"
  resource_type = "azurerm_redis_cache"
  suffixes      = [var.environment]
}

resource "azurerm_redis_cache" "cache" {
  name                = azurecaf_name.cache.result
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  minimum_tls_version = "1.2"

  # public network access will be allowed for non-prod so devs can do integration testing while debugging locally
  public_network_access_enabled = true

  # https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-configure#default-redis-server-configuration
  redis_configuration {
    enable_authentication = true
    active_directory_authentication_enabled = true
  }
}


resource "azurerm_redis_cache_access_policy_assignment" "current_user" {
  name               = "currentuser"
  redis_cache_id     = azurerm_redis_cache.cache.id
  access_policy_name = "Data Owner"
  object_id          = data.azuread_client_config.current.object_id
  object_id_alias    = "currentuser"
}

resource "azurerm_redis_cache_access_policy_assignment" "app_user" {
  name               = "appuser"
  redis_cache_id     = azurerm_redis_cache.cache.id
  access_policy_name = "Data Contributor"
  object_id          = azurerm_user_assigned_identity.app_service_identity.principal_id
  object_id_alias    = azurerm_user_assigned_identity.app_service_identity.principal_id
}


resource "azurerm_redis_cache_access_policy_assignment" "appservice_user" {
  name               = "appserviceuser"
  redis_cache_id     = azurerm_redis_cache.cache.id
  access_policy_name = "Data Contributor"
  object_id          = azurerm_linux_web_app.application.identity[0].principal_id
  object_id_alias    = azurerm_linux_web_app.application.identity[0].principal_id
}


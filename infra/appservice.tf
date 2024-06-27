resource "azurecaf_name" "app_service_plan" {
  name          = var.environment_name
  resource_type = "azurerm_app_service_plan"
}

resource "azurerm_service_plan" "application" {
  location            = var.location
  name                = azurecaf_name.app_service_plan.result
  resource_group_name = azurerm_resource_group.resource_group.name
  sku_name            = "P1v3"
  os_type             = "Linux"
}


resource "azurecaf_name" "app_service" {
  name          = var.environment_name
  resource_type = "azurerm_app_service"
}

resource "azurerm_linux_web_app" "application" {
  location            = var.location
  name                = azurecaf_name.app_service.result
  resource_group_name = azurerm_resource_group.resource_group.name
  service_plan_id     = azurerm_service_plan.application.id

  identity {
    type = "UserAssigned"
    identity_ids = [
        azurerm_user_assigned_identity.app_service_identity.id
    ]
  }

  site_config {
    application_stack {
      java_server = "JAVA"
      java_server_version = "17"
      java_version = "17"
    }

  }

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app_insights.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    AZURE_CACHE_REDIS_HOST = azurerm_redis_cache.cache.hostname
    AZURE_CACHE_REDIS_USERNAME = azurerm_user_assigned_identity.app_service_identity.principal_id
  }

  logs {
    http_logs {
      file_system {
        retention_in_mb   = 35
        retention_in_days = 30
      }
    }
  }

  tags = {
    "azd-service-name" = "application"
  }
}


# Configure Diagnostic Settings for App Service
resource "azurerm_monitor_diagnostic_setting" "app_service_diagnostic" {
  name                           = "app-service-diagnostic-settings"
  target_resource_id             = azurerm_linux_web_app.application.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.app_workspace.id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
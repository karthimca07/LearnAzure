variable "name" {
  type        = string
  description = "The name of the app service"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The location of the app service"
}

variable "service_plan_id" {
  type        = string
  description = "The ID of the App Service Plan to use"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the app service"
  default     = {}
}

variable "app_settings" {
  type        = map(string)
  description = "Application settings for the app service"
  default     = {}
}

variable "allowed_origins" {
  type        = list(string)
  description = "CORS allowed origins"
  default     = []
}

resource "azurerm_windows_web_app" "app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  tags                = var.tags

  site_config {
    application_stack {
      dotnet_version = "v7.0"
    }
    always_on = true

    dynamic "cors" {
      for_each = length(var.allowed_origins) > 0 ? [1] : []
      content {
        allowed_origins = var.allowed_origins
      }
    }
  }

  app_settings = merge({
    "ASPNETCORE_ENVIRONMENT" = "Production"
  }, var.app_settings)
}

output "default_hostname" {
  value = azurerm_windows_web_app.app.default_hostname
}

output "name" {
  value = azurerm_windows_web_app.app.name
}

output "id" {
  value = azurerm_windows_web_app.app.id
}

variable "name" {
  type        = string
  description = "Name of the Web App"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "service_plan_id" {
  type        = string
  description = "ID of the App Service Plan"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "app_settings" {
  type        = map(string)
  description = "App settings for the web app"
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

  app_settings = var.app_settings
}

output "default_hostname" {
  value = azurerm_windows_web_app.app.default_hostname
}

output "name" {
  value = azurerm_windows_web_app.app.name
}

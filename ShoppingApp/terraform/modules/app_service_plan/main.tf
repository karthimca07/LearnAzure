variable "name" {
  type        = string
  description = "Name of the App Service Plan"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "sku_name" {
  type        = string
  description = "SKU name for the App Service Plan"
  default     = "B1"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

resource "azurerm_service_plan" "plan" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type            = "Windows"
  sku_name           = var.sku_name
  tags               = var.tags
}

output "id" {
  value = azurerm_service_plan.plan.id
}

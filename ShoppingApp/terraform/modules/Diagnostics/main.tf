variable "name" {
  type        = string
  description = "Name of the LOG Analytics Workspace"
  default     = "law-shopping-dev"
}
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}  

variable "location" {
  type        = string
  description = "Azure region"
  default     = "East US"
}

resource "azurerm_log_analytics_workspace" "law-shopping-dev" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  retention_in_days   = 30
}

output "id" {
  value = azurerm_log_analytics_workspace.law-shopping-dev.id
}
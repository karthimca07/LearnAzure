# Azure Authentication variables
variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID"
}

variable "client_id" {
  type        = string
  description = "The Azure Service Principal Client ID"
}

variable "client_secret" {
  type        = string
  description = "The Azure Service Principal Client Secret"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "The Azure AD Tenant ID"
}

# General variables
variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "shoppingapp"
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created"
  default     = "eastus"
}

# Resource group variables
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
  default     = null
}

# App Service variables
variable "app_service_sku" {
  type        = string
  description = "The SKU for the App Service Plan"
  default     = "B1"
}

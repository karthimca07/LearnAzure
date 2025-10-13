variable "name" {
  type        = string
  description = "Name of the API Management service"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "publisher_name" {
  type        = string
  description = "Publisher name for the API Management"
}

variable "publisher_email" {
  type        = string
  description = "Publisher email for the API Management"
}

variable "sku" {
  type        = string
  description = "SKU of the API Management service"
  default     = "Consumption"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name           = "${var.sku}_0"  # Consumption_0 for serverless tier

  tags = var.tags
}

# Create an API within APIM
resource "azurerm_api_management_api" "shopping_api" {
  name                = "shopping-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  revision           = "1"
  display_name       = "Shopping API"
  path               = "api"
  protocols          = ["https"]
  service_url        = "https://app-shopping-api-dev.azurewebsites.net/api"
  subscription_required = false
}

resource "azurerm_api_management_api_operation" "shopping_api_GetProducts" {
  operation_id        = "get-products"
  api_name            = azurerm_api_management_api.shopping_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name       = "Get Products"
  method             = "GET"
  url_template       = "/products"
}

variable "name" {
    type        = string
  description = "Name of the Front Door"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "front_door_sku_name" {
  type        = string
  description = "SKU name for the Front Door"
  default     = "Standard_AzureFrontDoor"
}


resource "azurerm_cdn_frontdoor_profile" "fdProfile" {
    name                = var.name
    resource_group_name = var.resource_group_name
    sku_name            = var.front_door_sku_name
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
    name                = "${var.name}-endpoint"
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdProfile.id
}

resource "azurerm_cdn_frontdoor_origin_group" "fd_orgin_group" {
  name = "${var.name}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdProfile.id

  load_balancing {
    sample_size = 4
    successful_samples_required = 2
  }
  
  health_probe {
    path = "/status-0123456789abcdef"
    request_type = "GET"
    protocol = "Https"
    interval_in_seconds = 120
  }
}

resource "azurerm_cdn_frontdoor_origin" "apim_origin" {
  name = "apim-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_orgin_group.id
  
  enabled = true
  host_name = "apim-shopping-dev.azure-api.net"
  origin_host_header = "apim-shopping-dev.azure-api.net"
  http_port = 80
  https_port = 443
  priority = 1
  weight = 50
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "route" {
    name = "${var.name}-route"
    cdn_frontdoor_endpoint_id = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
    cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_orgin_group.id
    cdn_frontdoor_origin_ids = [azurerm_cdn_frontdoor_origin.apim_origin.id]
    
    supported_protocols = ["Http", "Https"]
    patterns_to_match = ["/*"]
    forwarding_protocol = "HttpsOnly"
    link_to_default_domain = true
    https_redirect_enabled = true
}

output "id" {
  value = azurerm_cdn_frontdoor_profile.fdProfile.id
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Local variables
locals {
  environment = terraform.workspace
  location    = "eastus"
  common_tags = {
    Environment = local.environment
    Project     = "ShoppingApp"
    ManagedBy   = "Terraform"
  }
}

# Resource Group
module "resource_group" {
  source = "./modules/resource_group"
  name     = "rg-shoppingapp-${local.environment}"
  location = local.location
  tags     = local.common_tags
}

# App Service Plan (shared by both apps)
module "app_service_plan" {
  source              = "./modules/app_service_plan"
  name                = "asp-shoppingapp-${local.environment}"
  resource_group_name = module.resource_group.name
  location            = local.location
  sku_name            = local.environment == "prod" ? "P1v2" : "B1"
  tags                = local.common_tags
}

# API App (Create this first)
module "api" {
  source              = "./modules/web_app"
  name                = "app-shopping-api-${local.environment}"
  resource_group_name = module.resource_group.name
  location            = local.location
  service_plan_id     = module.app_service_plan.id
  tags                = local.common_tags
  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = local.environment
  }
}

# API Management
module "apim" {
  source              = "./modules/apim"
  name                = "apim-shopping-${local.environment}"
  resource_group_name = module.resource_group.name
  location            = local.location
  publisher_name      = "Shopping App Team"
  publisher_email     = "admin@shoppingapp.com"
  tags                = local.common_tags
}

# Web App (Frontend)
module "webapp" {
  source              = "./modules/web_app"
  name                = "app-shopping-web-${local.environment}"
  resource_group_name = module.resource_group.name
  location            = local.location
  service_plan_id     = module.app_service_plan.id
  tags                = local.common_tags
  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = local.environment
    "ApiBaseUrl"            = "https://${module.api.default_hostname}"
  }
}

module "frontdoor" {
  source              = "./modules/frontdoor"
  name                = "fd-shopping-${local.environment}"
  resource_group_name = module.resource_group.name
}

module "logAnalyticWorkspace" {
  source              = "./modules/Diagnostics"
  name                = "law-shopping-${local.environment}"
  resource_group_name = module.resource_group.name
  location            = local.location
}

resource "azurerm_monitor_diagnostic_setting" "fd_adig" {
  name = "fd-to-law"
  target_resource_id = module.frontdoor.id
  log_analytics_workspace_id = module.logAnalyticWorkspace.id

  log {
    category = "FrontdoorAccessLog"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  
  }

    log {
    category = "frontdoorWebApplicationFirewallLog"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "FrontdoorHealthProbeLog"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }
}
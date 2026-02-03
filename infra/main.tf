########################
# Existing Resource Group (DO NOT CREATE)
########################
data "azurerm_resource_group" "app" {
  name = var.resource_group_name
}

########################
# App Service Plan
########################
resource "azurerm_service_plan" "plan" {
  name                = "${var.name_prefix}-plan"
  location            = data.azurerm_resource_group.app.location
  resource_group_name = data.azurerm_resource_group.app.name
  os_type             = "Linux"
  sku_name            = var.sku_name
}

########################
# Linux Web App 1
########################
resource "azurerm_linux_web_app" "app" {
  name                = "${var.name_prefix}-app"
  location            = data.azurerm_resource_group.app.location
  resource_group_name = data.azurerm_resource_group.app.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = true

    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}

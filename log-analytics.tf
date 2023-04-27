resource "azurerm_log_analytics_workspace" "default" {
  count = local.existing_log_analytics_workspace == "" ? 1 : 0

  name                = local.resource_prefix
  resource_group_name = local.resource_group.name
  location            = local.resource_group.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

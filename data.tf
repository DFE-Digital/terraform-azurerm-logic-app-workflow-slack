data "azurerm_resource_group" "existing_resource_group" {
  count = local.existing_resource_group == "" ? 0 : 1

  name = local.existing_resource_group
}

data "azurerm_log_analytics_workspace" "existing_log_analytics_workspace" {
  count = local.existing_log_analytics_workspace == "" ? 0 : 1

  resource_group_name = local.resource_group.name
  name                = local.existing_log_analytics_workspace
}

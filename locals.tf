locals {
  environment                      = var.environment
  project_name                     = var.project_name
  resource_prefix                  = "${local.environment}${local.project_name}"
  azure_location                   = var.azure_location
  tags                             = var.tags
  existing_resource_group          = var.existing_resource_group
  resource_group                   = local.existing_resource_group == "" ? azurerm_resource_group.default[0] : data.azurerm_resource_group.existing_resource_group[0]
  enable_resource_group_lock       = var.enable_resource_group_lock
  existing_log_analytics_workspace = var.existing_log_analytics_workspace
  log_analytics_workspace          = local.existing_resource_group == "" ? azurerm_log_analytics_workspace.default[0] : data.azurerm_log_analytics_workspace.existing_log_analytics_workspace[0]
  log_analytics_workspace_id       = local.log_analytics_workspace.id
}

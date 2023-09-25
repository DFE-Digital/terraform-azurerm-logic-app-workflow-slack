locals {
  environment     = var.environment
  project_name    = var.project_name
  resource_prefix = "${local.environment}${local.project_name}"
  azure_location  = var.azure_location
  tags            = var.tags

  enable_diagnostic_setting                = var.enable_diagnostic_setting
  enable_diagnostic_setting_retention      = var.enable_diagnostic_setting_retention
  diagnostic_setting_retention_period_days = var.diagnostic_setting_retention_period_days

  existing_resource_group    = var.existing_resource_group
  resource_group             = local.existing_resource_group == "" ? azurerm_resource_group.default[0] : data.azurerm_resource_group.existing_resource_group[0]
  enable_resource_group_lock = var.enable_resource_group_lock

  existing_log_analytics_workspace    = var.existing_log_analytics_workspace
  log_analytics_workspace             = local.existing_resource_group == "" ? azurerm_log_analytics_workspace.default[0] : data.azurerm_log_analytics_workspace.existing_log_analytics_workspace[0]
  log_analytics_workspace_id          = local.log_analytics_workspace.id
  log_analytics_retention_period_days = var.log_analytics_retention_period_days

  workflow_cases = { for resource_group_name, case in var.resource_group_target_webhooks :
    resource_group_name => {
      body : templatefile(
        "${path.module}/webhook/slack-webhook-metric-alert.json.tpl",
        {
          channel = case.channel_id
        }
      )
      uri : case.webhook_url
    }
  }

  workflow_switch = templatefile(
    "${path.module}/templates/actions/switch.json.tpl",
    {
      var_name  = "@variables('affectedResource')[4]" # Resource Group
      run_after = azurerm_logic_app_action_custom.var_alarm_context.name
      cases     = local.workflow_cases
    }
  )
}

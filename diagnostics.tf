resource "azurerm_monitor_diagnostic_setting" "default" {
  count = local.enable_diagnostic_setting ? 1 : 0

  name                           = "${local.resource_prefix}-diag"
  target_resource_id             = azurerm_logic_app_workflow.default.id
  log_analytics_workspace_id     = local.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "WorkflowRuntime"

    retention_policy {
      enabled = local.enable_diagnostic_setting_retention
      days    = local.diagnostic_setting_retention_period_days
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = local.enable_diagnostic_setting_retention
      days    = local.diagnostic_setting_retention_period_days
    }
  }
}

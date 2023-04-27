resource "azurerm_logic_app_workflow" "default" {
  name                = local.resource_prefix
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  tags = local.tags
}

resource "azurerm_logic_app_trigger_http_request" "default" {
  name         = "${local.resource_prefix}-trigger"
  logic_app_id = azurerm_logic_app_workflow.default.id
  schema       = templatefile("${path.module}/schema/common-alert-schema.json", {})
}

resource "azurerm_monitor_diagnostic_setting" "default" {
  name                           = "${local.resource_prefix}-diag"
  target_resource_id             = azurerm_logic_app_workflow.default.id
  log_analytics_workspace_id     = local.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "WorkflowRuntime"

    retention_policy {
      enabled = true
      days    = 7
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 7
    }
  }
}

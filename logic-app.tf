resource "azurerm_logic_app_workflow" "default" {
  name                = local.resource_prefix
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  tags = local.tags
}

resource "azurerm_logic_app_trigger_http_request" "default" {
  name         = "http-request-trigger"
  logic_app_id = azurerm_logic_app_workflow.default.id
  schema       = local.trigger_alert_schema
}

resource "azurerm_logic_app_action_custom" "var_affected_resource" {
  name         = "var-affected-resource"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = local.var_affected_resource
}

resource "azurerm_logic_app_action_custom" "var_alarm_context" {
  name         = "var-alarm-context"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = local.var_alarm_context
}

resource "azurerm_logic_app_action_custom" "var_alarm_severity" {
  name         = "var-alarm-severity"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = local.var_alarm_severity
}

resource "azurerm_logic_app_action_custom" "var_signal_type" {
  name         = "var-signal-type"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = local.var_signal_type
}

resource "azurerm_logic_app_action_custom" "condition_check_for_waf" {
  name         = "condition-waf-resource-group"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = local.waf_condition

  depends_on = [
    azurerm_logic_app_action_custom.var_affected_resource,
    azurerm_logic_app_action_custom.var_alarm_context,
    azurerm_logic_app_action_custom.var_alarm_severity,
    azurerm_logic_app_action_custom.var_signal_type
  ]
}

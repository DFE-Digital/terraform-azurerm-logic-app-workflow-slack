resource "azurerm_logic_app_workflow" "default" {
  name                = local.resource_prefix
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name

  tags = local.tags
}

resource "azurerm_logic_app_trigger_http_request" "default" {
  name         = "${local.resource_prefix}-trigger"
  logic_app_id = azurerm_logic_app_workflow.default.id
  schema       = local.trigger_alert_schema
}

resource "azurerm_logic_app_action_custom" "var_affected_resource" {
  name         = "${local.resource_prefix}-setvars0"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = local.var_affected_resource
}

resource "azurerm_logic_app_action_custom" "var_alarm_context" {
  name         = "${local.resource_prefix}-setvars1"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = local.var_alarm_context
}

resource "azurerm_logic_app_action_custom" "condition_check_for_waf" {
  name         = "${local.resource_prefix}-condition"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = local.waf_condition
}

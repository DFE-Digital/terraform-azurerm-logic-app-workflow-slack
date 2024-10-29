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

resource "azurerm_logic_app_action_custom" "var" {
  for_each = local.workflow_variables

  name         = "var-${each.key}"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = each.value
}

resource "azurerm_logic_app_action_custom" "condition_check_for_waf" {
  name         = "condition-waf-resource-group"
  logic_app_id = azurerm_logic_app_workflow.default.id
  body         = local.waf_condition

  depends_on = [
    azurerm_logic_app_action_custom.var
  ]
}

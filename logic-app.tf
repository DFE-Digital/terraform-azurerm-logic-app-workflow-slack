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

resource "azurerm_logic_app_action_custom" "var_affected_resource" {
  name         = "${local.resource_prefix}-setvars0"
  logic_app_id = azurerm_logic_app_workflow.default.id

  body = templatefile("${path.module}/templates/variables/affected-resource.json.tpl", {})
}

resource "azurerm_logic_app_action_custom" "var_alarm_context" {
  name         = "${local.resource_prefix}-setvars1"
  logic_app_id = azurerm_logic_app_workflow.default.id

  body = templatefile("${path.module}/templates/variables/alarm-context.json.tpl", {
    run_after = azurerm_logic_app_action_custom.var_affected_resource.name
  })
}

resource "azurerm_logic_app_action_custom" "switch" {
  name         = "${local.resource_prefix}-switch"
  logic_app_id = azurerm_logic_app_workflow.default.id

  body = local.workflow_switch

  depends_on = [azurerm_logic_app_action_custom.var_affected_resource, azurerm_logic_app_action_custom.var_alarm_context]
}

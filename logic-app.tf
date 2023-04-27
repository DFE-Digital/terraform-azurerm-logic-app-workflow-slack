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

resource "azurerm_logic_app_action_custom" "vars" {
  name         = "${local.resource_prefix}-setvar"
  logic_app_id = azurerm_logic_app_workflow.default.id

  body = <<BODY
  {
    "description": "Set a variable that holds the Resource Group name",
    "inputs": {
      "variables": [
        {
          "name": "affectedResourceGroup",
          "type": "string",
          "value": "@{split(triggerBody()?['data']?['essentials']?['alertTargetIDs'][0], '/')[4]}"
        }
      ]
    },
    "runAfter": {},
    "type": "InitializeVariable"
  }
  BODY
}

resource "azurerm_logic_app_action_custom" "switch" {
  name         = "${local.resource_prefix}-switch"
  logic_app_id = azurerm_logic_app_workflow.default.id

  body = local.workflow_switch
}

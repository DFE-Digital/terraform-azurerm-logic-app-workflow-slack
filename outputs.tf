output "logic_app_receiver" {
  description = "Logic App Reciever block, suitable for plugging in to an azurerm_monitor_action_group"
  value = {
    name                    = azurerm_logic_app_workflow.default.name
    use_common_alert_schema = true
    resource_id             = azurerm_logic_app_workflow.default.id
    callback_url            = azurerm_logic_app_trigger_http_request.default.callback_url
  }
}

output "workflow_cases" {
  description = "JSON object containing all the different switch cases used for conditionally routing alerts"
  value       = local.workflow_cases
}

output "workflow_code_view" {
  description = "JSON output that can be rendered in the Logic App Workflow designer view"
  value       = local.workflow_switch
}
output "logic_app_workflow" {
  description = "Logic App Workflow"
  value       = azurerm_logic_app_workflow.default.name
}

output "logic_app_workflow_trigger" {
  description = "Logic App Workflow Trigger"
  value       = azurerm_logic_app_trigger_http_request.default
}

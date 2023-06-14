output "logic_app_workflow" {
  description = "Logic App Workflow"
  value       = azurerm_logic_app_workflow.default.name
}

output "logic_app_workflow_trigger" {
  description = "Logic App Workflow Trigger"
  value       = azurerm_logic_app_trigger_http_request.default
}

output "resource_group" {
  description = "The Resource Group the Logic App was deployed to"
  value       = local.resource_group
}

output "azurerm_log_analytics_workspace" {
  description = "Log Analytics Workspace linked to the Logic App Workflow"
  value       = local.log_analytics_workspace
}

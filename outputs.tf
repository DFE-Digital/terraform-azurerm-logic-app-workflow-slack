output "logic_app_webhook_endpoint" {
  value = azurerm_logic_app_trigger_http_request.default.callback_url
}

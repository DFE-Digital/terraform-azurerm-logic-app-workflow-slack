locals {
  environment     = var.environment
  project_name    = var.project_name
  resource_prefix = "${local.environment}${local.project_name}"
  azure_location  = var.azure_location
  tags            = var.tags

  enable_diagnostic_setting = var.enable_diagnostic_setting

  existing_resource_group    = var.existing_resource_group
  resource_group             = local.existing_resource_group == "" ? azurerm_resource_group.default[0] : data.azurerm_resource_group.existing_resource_group[0]
  enable_resource_group_lock = var.enable_resource_group_lock

  existing_log_analytics_workspace    = var.existing_log_analytics_workspace
  log_analytics_workspace             = local.existing_resource_group == "" ? azurerm_log_analytics_workspace.default[0] : data.azurerm_log_analytics_workspace.existing_log_analytics_workspace[0]
  log_analytics_workspace_id          = local.log_analytics_workspace.id
  log_analytics_retention_period_days = var.log_analytics_retention_period_days

  trigger_alert_schema = templatefile("${path.module}/schema/common-alert-schema.json", {})

  var_affected_resource = templatefile("${path.module}/templates/variables/affected-resource.json.tpl", {})
  var_alarm_context = templatefile("${path.module}/templates/variables/alarm-context.json.tpl", {
    run_after = azurerm_logic_app_action_custom.var_affected_resource.name
  })

  route_waf_logs       = var.route_waf_logs
  waf_logs_channel_id  = var.waf_logs_channel_id
  waf_logs_webhook_url = var.waf_logs_webhook_url
  waf_webhook = templatefile(
    "${path.module}/templates/actions/http.json.tpl",
    {
      body = templatefile(
        "${path.module}/webhook/slack-webhook-waf-alert.json.tpl",
        {
          channel = local.waf_logs_channel_id
        }
      )
      headers = jsonencode({
        "Content-Type" : "application/json"
      })
      method = "POST"
      uri    = local.waf_logs_webhook_url
    }
  )
  waf_condition = templatefile(
    "${path.module}/templates/actions/condition.json.tpl",
    {
      name = "waf"
      run_after = jsonencode({
        (azurerm_logic_app_action_custom.var_alarm_context.name) : ["Succeeded"]
      })
      haystack        = "@variables('affectedResource')[4]" # Resource Group
      condition       = "contains"
      needle          = "waf"
      action_if_true  = local.route_waf_logs ? local.waf_webhook : jsonencode({})
      action_if_false = local.workflow_switch
    }
  )

  resource_group_target_webhooks = var.resource_group_target_webhooks
  workflow_cases = { for resource_group_name, case in local.resource_group_target_webhooks :
    resource_group_name => {
      action : templatefile(
        "${path.module}/templates/actions/condition.json.tpl",
        {
          name      = resource_group_name
          run_after = jsonencode({})
          haystack  = "@if(equals(variables('alarmContext')?['metricName'], null), 'no', 'yes')"
          condition = "equals"
          needle    = "yes"
          action_if_true = templatefile(
            "${path.module}/templates/actions/http.json.tpl",
            {
              body = templatefile(
                "${path.module}/webhook/slack-webhook-metric-alert.json.tpl",
                {
                  channel = case.channel_id
                }
              )
              headers = jsonencode({
                "Content-Type" : "application/json"
              })
              method = "POST"
              uri    = case.webhook_url
            }
          )
          action_if_false = templatefile(
            "${path.module}/templates/actions/http.json.tpl",
            {
              body = templatefile(
                "${path.module}/webhook/slack-webhook-log-alert.json.tpl",
                {
                  channel = case.channel_id
                }
              )
              headers = jsonencode({
                "Content-Type" : "application/json"
              })
              method = "POST"
              uri    = case.webhook_url
            }
          )
        }
      )
    }
  }

  workflow_switch = templatefile(
    "${path.module}/templates/actions/switch.json.tpl",
    {
      run_after  = jsonencode({})
      expression = "@variables('affectedResource')[4]" # Resource Group
      cases      = local.workflow_cases
    }
  )
}

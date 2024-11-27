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
  var_webhook_map = templatefile("${path.module}/templates/variables/webhook-map.json.tpl", {
    map = jsonencode({ for resource_group, webhook in local.resource_group_target_webhooks : (resource_group) => {
      "webhook_url" : webhook.webhook_url,
      "channel_id" : webhook.channel_id,
      "message_tag" : webhook.message_tag,
      "sev1_webhook_url" : webhook.sev1_webhook_url != "" ? webhook.sev1_webhook_url : webhook.webhook_url,
      "sev1_channel_id" : webhook.sev1_channel_id != "" ? webhook.sev1_channel_id : webhook.channel_id,
      "sev1_message_tag" : webhook.sev1_message_tag != "" ? webhook.sev1_message_tag : webhook.message_tag,
      }
    })
  })
  var_resource_group = templatefile("${path.module}/templates/variables/resource-group.json.tpl", {})
  var_alarm_context  = templatefile("${path.module}/templates/variables/alarm-context.json.tpl", {})
  var_alarm_severity = templatefile("${path.module}/templates/variables/severity.json.tpl", {})
  var_signal_type    = templatefile("${path.module}/templates/variables/signal-type.json.tpl", {})
  var_is_waf         = templatefile("${path.module}/templates/variables/is-waf-event.json.tpl", {})
  var_tenant_id = templatefile("${path.module}/templates/variables/tenant-id.json.tpl", {
    tenant_id = data.azurerm_subscription.current.tenant_id
  })

  workflow_variables = {
    "affected-resource" : local.var_affected_resource,
    "resource-group" : local.var_resource_group,
    "webhook-map" : local.var_webhook_map,
    "alarm-context" : local.var_alarm_context,
    "alarm-severity" : local.var_alarm_severity,
    "signal-type" : local.var_signal_type,
    "is-waf" : local.var_is_waf,
    "tenant-id" : local.var_tenant_id,
  }

  route_waf_logs       = var.route_waf_logs
  waf_logs_channel_id  = var.waf_logs_channel_id
  waf_logs_webhook_url = var.waf_logs_webhook_url

  waf_webhook = templatefile(
    "${path.module}/templates/actions/http.json.tpl",
    {
      body = templatefile(
        "${path.module}/webhook/slack-webhook-waf-alert.json.tpl",
        {
          channel     = local.waf_logs_channel_id
          message_tag = ""
        }
      )
      headers = jsonencode({
        "Content-Type" : "application/json"
      })
      method      = "POST"
      uri         = local.waf_logs_webhook_url
      description = "Send WAF Log alert to Slack Channel ID ${local.waf_logs_channel_id}"
    }
  )

  waf_condition = templatefile(
    "${path.module}/templates/actions/condition.json.tpl",
    {
      name = "affectedResource.contains.waf"
      run_after = jsonencode({
        for variable in azurerm_logic_app_action_custom.var : (variable.name) => [
          "Succeeded"
        ]
      })
      expressions = jsonencode([
        {
          "equals" = [
            "@variables('isWAF')",
            true
          ]
        }
      ])
      action_if_true  = local.route_waf_logs ? local.waf_webhook : jsonencode({})
      action_if_false = local.conditiontype_switch
      description     = "Check if affected resource group name contains 'waf'"
    }
  )

  conditiontype_switch = templatefile(
    "${path.module}/templates/actions/switch.json.tpl",
    {
      name        = "conditionType.switch"
      run_after   = jsonencode({})
      expression  = "@replace(triggerBody()?['data']?['essentials']?['targetResourceType'], '/', '.')"
      description = "Check to see what resource type the alert is bound to"
      cases = {
        "microsoft.operationalinsights.workspaces" : { # Alert for Log Analytics
          "action" : local.log_webhook
        }
      }
      default_action = local.signaltype_switch
    }
  )

  signaltype_switch = templatefile(
    "${path.module}/templates/actions/switch.json.tpl",
    {
      name        = "signalType.switch"
      run_after   = jsonencode({})
      expression  = "@variables('signalType')"
      description = "Check to see what signal type the alert is bound to"
      cases = {
        "Metric" : { # Alert for Metric alarms
          "action" : local.metric_webhook
        },
        "Activity Log" : { # Alert for Activity Log alarms
          "action" : local.activity_webhook
        }
        "Log" : { # Alert for Log Query alarms
          "action" : local.exception_webhook
        }
      }
      default_action = jsonencode([])
    }
  )

  activity_webhook = templatefile(
    "${path.module}/templates/actions/http.json.tpl",
    {
      body = templatefile(
        "${path.module}/webhook/slack-webhook-activity-alert.json.tpl",
        {
          channel     = "@variables('webhookMap')[variables('resourceGroup')]['channel_id']"
          message_tag = "@variables('webhookMap')[variables('resourceGroup')]['message_tag']"
        }
      )
      headers = jsonencode({
        "Content-Type" : "application/json"
      })
      description = "Send an Activity Log alert to Slack Channel"
      method      = "POST"
      uri         = "@variables('webhookMap')[variables('resourceGroup')]['webhook_url']"
    }
  )

  metric_webhook = templatefile(
    "${path.module}/templates/actions/http.json.tpl",
    {
      body = templatefile(
        "${path.module}/webhook/slack-webhook-metric-alert.json.tpl",
        {
          channel     = "@if(or(equals(variables('alarmSeverity'), 'Sev1'), equals(variables('alarmSeverity'), 'Sev0')), variables('webhookMap')[variables('resourceGroup')]['sev1_channel_id'], variables('webhookMap')[variables('resourceGroup')]['channel_id'])"
          message_tag = "@if(or(equals(variables('alarmSeverity'), 'Sev1'), equals(variables('alarmSeverity'), 'Sev0')), variables('webhookMap')[variables('resourceGroup')]['sev1_message_tag'], variables('webhookMap')[variables('resourceGroup')]['message_tag'])"
        }
      )
      headers = jsonencode({
        "Content-Type" : "application/json"
      })
      description = "Send a Metric alert to Slack Channel"
      method      = "POST"
      uri         = "@if(or(equals(variables('alarmSeverity'), 'Sev1'), equals(variables('alarmSeverity'), 'Sev0')), variables('webhookMap')[variables('resourceGroup')]['sev1_webhook_url'], variables('webhookMap')[variables('resourceGroup')]['webhook_url'])"
    }
  )

  exception_webhook = templatefile(
    "${path.module}/templates/actions/http.json.tpl",
    {
      body = templatefile(
        "${path.module}/webhook/slack-webhook-exception-alert.json.tpl",
        {
          channel     = "@if(or(equals(variables('alarmSeverity'), 'Sev1'), equals(variables('alarmSeverity'), 'Sev0')), variables('webhookMap')[variables('resourceGroup')]['sev1_channel_id'], variables('webhookMap')[variables('resourceGroup')]['channel_id'])"
          message_tag = "@if(or(equals(variables('alarmSeverity'), 'Sev1'), equals(variables('alarmSeverity'), 'Sev0')), variables('webhookMap')[variables('resourceGroup')]['sev1_message_tag'], variables('webhookMap')[variables('resourceGroup')]['message_tag'])"
        }
      )
      headers = jsonencode({
        "Content-Type" : "application/json"
      })
      description = "Send an Exception alert to Slack Channel"
      method      = "POST"
      uri         = "@if(or(equals(variables('alarmSeverity'), 'Sev1'), equals(variables('alarmSeverity'), 'Sev0')), variables('webhookMap')[variables('resourceGroup')]['sev1_webhook_url'], variables('webhookMap')[variables('resourceGroup')]['webhook_url'])"
    }
  )

  log_webhook = templatefile(
    "${path.module}/templates/actions/http.json.tpl",
    {
      body = templatefile(
        "${path.module}/webhook/slack-webhook-log-alert.json.tpl",
        {
          channel     = "@if(or(equals(variables('alarmSeverity'), 'Sev1'), equals(variables('alarmSeverity'), 'Sev0')), variables('webhookMap')[variables('resourceGroup')]['sev1_channel_id'], variables('webhookMap')[variables('resourceGroup')]['channel_id'])"
          message_tag = "@if(or(equals(variables('alarmSeverity'), 'Sev1'), equals(variables('alarmSeverity'), 'Sev0')), variables('webhookMap')[variables('resourceGroup')]['sev1_message_tag'], variables('webhookMap')[variables('resourceGroup')]['message_tag'])"
        }
      )
      headers = jsonencode({
        "Content-Type" : "application/json"
      })
      description = "Send a Log alert to Slack Channel"
      method      = "POST"
      uri         = "@if(or(equals(variables('alarmSeverity'), 'Sev1'), equals(variables('alarmSeverity'), 'Sev0')), variables('webhookMap')[variables('resourceGroup')]['sev1_webhook_url'], variables('webhookMap')[variables('resourceGroup')]['webhook_url'])"
    }
  )

  resource_group_target_webhooks = var.resource_group_target_webhooks
}

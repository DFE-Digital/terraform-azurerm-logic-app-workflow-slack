# terraform-azurerm-logic-app-workflow-slack

[![Terraform CI](./actions/workflows/continuous-integration-terraform.yml/badge.svg?branch=main)](./actions/workflows/continuous-integration-terraform.yml?branch=main)
[![GitHub release](./releases)](./releases)

This module creates and manages an Azure Logic App Workflow.

## Usage

Example module usage:

```hcl
module "azurerm_logic_app_workflow" {
  source              = "github.com/DFE-Digital/terraform-azurerm-logic-app-workflow-slack"
  environment         = "my-env"
  project_name        = "my-proj"
  azure_location      = "uksouth"
  resource_group_target_webhooks = {
    "my-resource-group" = {
      webhook_url = "https://hooks.slack.com/services/XXX/YYY/ZZZZZZ"
      channel_id        = "ABCABCABC"
    },
    "my-other-resource-group" = {
      webhook_url = "https://hooks.slack.com/services/XXX/YYY/ZZZZZZ"
      channel_id        = "ABCABCABC"
    }
  }

  tags = {
    "Key" = "Value"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.53.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_workspace.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_logic_app_action_custom.switch](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_action_custom) | resource |
| [azurerm_logic_app_action_custom.var_affected_resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_action_custom) | resource |
| [azurerm_logic_app_action_custom.var_alarm_context](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_action_custom) | resource |
| [azurerm_logic_app_trigger_http_request.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_trigger_http_request) | resource |
| [azurerm_logic_app_workflow.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_workflow) | resource |
| [azurerm_management_lock.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_monitor_diagnostic_setting.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_log_analytics_workspace.existing_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.existing_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Azure location in which to launch resources. | `string` | n/a | yes |
| <a name="input_diagnostic_setting_retention_period_days"></a> [diagnostic\_setting\_retention\_period\_days](#input\_diagnostic\_setting\_retention\_period\_days) | Retention period for diagnostic logs in days | `number` | `7` | no |
| <a name="input_enable_diagnostic_setting"></a> [enable\_diagnostic\_setting](#input\_enable\_diagnostic\_setting) | Enable Diagnostics for the Logic App Workflow and send data to Log Analytics | `bool` | `true` | no |
| <a name="input_enable_diagnostic_setting_retention"></a> [enable\_diagnostic\_setting\_retention](#input\_enable\_diagnostic\_setting\_retention) | Specify a retention period for Diagnostics. Has no effect if 'enable\_diagnostic\_setting' is false | `bool` | `true` | no |
| <a name="input_enable_resource_group_lock"></a> [enable\_resource\_group\_lock](#input\_enable\_resource\_group\_lock) | Enabling this will add a Resource Lock to the Resource Group preventing any resources from being deleted. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. Will be used along with `project_name` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_existing_log_analytics_workspace"></a> [existing\_log\_analytics\_workspace](#input\_existing\_log\_analytics\_workspace) | Conditionally send Diagnostics into an existing Log Analytics Workspace. Specifying this will NOT create a new resource | `string` | `""` | no |
| <a name="input_existing_resource_group"></a> [existing\_resource\_group](#input\_existing\_resource\_group) | Conditionally launch resources into an existing resource group. Specifying this will NOT create a resource group. | `string` | `""` | no |
| <a name="input_log_analytics_retention_period_days"></a> [log\_analytics\_retention\_period\_days](#input\_log\_analytics\_retention\_period\_days) | Retention period for logs in the Log Analyitcs Workspace. Has no effect if you are using an existing workspace | `number` | `30` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name. Will be used along with `environment` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_resource_group_target_webhooks"></a> [resource\_group\_target\_webhooks](#input\_resource\_group\_target\_webhooks) | Slack webhook destinations keyed by the Resource Group you want to collect webhooks from | <pre>map(<br>    object({<br>      webhook_url = string<br>      channel_id  = string<br>    })<br>  )</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logic_app_workflow"></a> [logic\_app\_workflow](#output\_logic\_app\_workflow) | Logic App Workflow |
| <a name="output_logic_app_workflow_trigger"></a> [logic\_app\_workflow\_trigger](#output\_logic\_app\_workflow\_trigger) | Logic App Workflow Trigger |
<!-- END_TF_DOCS -->

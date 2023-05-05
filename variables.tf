variable "environment" {
  description = "Environment name. Will be used along with `project_name` as a prefix for all resources."
  type        = string
}

variable "project_name" {
  description = "Project name. Will be used along with `environment` as a prefix for all resources."
  type        = string
}

variable "azure_location" {
  description = "Azure location in which to launch resources."
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_diagnostic_setting" {
  description = "Enable Diagnostics for the Logic App Workflow and send data to Log Analytics"
  type        = bool
  default     = true
}

variable "enable_diagnostic_setting_retention" {
  description = "Specify a retention period for Diagnostics. Has no effect if 'enable_diagnostic_setting' is false"
  type        = bool
  default     = true
}

variable "diagnostic_setting_retention_period_days" {
  description = "Retention period for diagnostic logs in days"
  type        = number
  default     = 7
}

variable "existing_resource_group" {
  description = "Conditionally launch resources into an existing resource group. Specifying this will NOT create a resource group."
  type        = string
  default     = ""
}

variable "enable_resource_group_lock" {
  description = "Enabling this will add a Resource Lock to the Resource Group preventing any resources from being deleted."
  type        = bool
  default     = false
}

variable "existing_log_analytics_workspace" {
  description = "Conditionally send Diagnostics into an existing Log Analytics Workspace. Specifying this will NOT create a new resource"
  type        = string
  default     = ""
}

variable "log_analytics_retention_period_days" {
  description = "Retention period for logs in the Log Analyitcs Workspace. Has no effect if you are using an existing workspace"
  type        = number
  default     = 30
}

variable "resource_group_target_webhooks" {
  description = "Slack webhook destinations keyed by the Resource Group you want to collect webhooks from"
  type = map(
    object({
      webhook_url = string
      channel_id  = string
    })
  )
  default   = {}
  sensitive = true
}
variable "api_name" {
  type = string
}

variable "stage_name" {
  type = string
}

variable "api_endpoint_type" {
  type    = string
  default = "REGIONAL"
}

variable "paths" {
  type = list(object({
    path               = string
    http_method        = optional(string)
    integration_uri    = string
    integration_type   = optional(string)
    integration_method = optional(string)
    payload_version    = optional(string)
  }))
}

variable "gateway_responses" {
  type = list(object({
    key         = string
    status_code = string
    templates   = map(string)
  }))

  default = [
    {
      key         = "DEFAULT_4XX"
      status_code = "403"
      templates = {
        "application/json" = "{\"message\": \"Access denied\"}"
      }
    },
    {
      key         = "MISSING_AUTHENTICATION_TOKEN"
      status_code = "404"
      templates = {
        "application/json" = "{\"message\": \"Not found\"}"
      }
    }
  ]
}

#-------------------------------------#
# iam

variable "create_lambda_permissions" {
  type    = bool
  default = false
}

variable "lambda_permission_names_list" {
  type    = list(string)
  default = []
}

variable "create_whitelist_api_resource_policy" {
  type    = bool
  default = false
}

variable "whitelist_ip_cidrs" {
  type    = list(string)
  default = []
}

variable "attach_iam_policies" {
  type        = list(string)
  default     = []
  description = "List of extra IAM policies to be attached to the role"
}

#-------------------------------------#
# domain

variable "create_custom_domain" {
  type    = bool
  default = false
}

variable "custom_domain" {
  type    = string
  default = ""
}

variable "custom_domain_cert_arn" {
  type    = string
  default = ""
}

variable "custom_domain_zone_id" {
  type    = string
  default = ""
}

variable "custom_domain_security_policy" {
  type    = string
  default = "TLS_1_2"
}

variable "custom_domain_endpoint_type" {
  type    = string
  default = "REGIONAL"
}

#-------------------------------------#
# logs

variable "cw_logs_enabled" {
  type    = bool
  default = true
}

variable "create_cw_log_group" {
  type    = bool
  default = true
}

variable "cw_log_group_name" {
  type        = string
  default     = ""
  description = "This is used only for new log group creation, thus 'create_cw_log_group' should be 'true'"
}

variable "cw_log_group_arn" {
  type        = string
  default     = ""
  description = "This is used only for existing log groups, thus 'create_cw_log_group' should be 'false'"
}

variable "cw_logs_retention" {
  type        = number
  default     = 7
  description = "CW logs retention in days"
}

variable "cw_logs_format" {
  type = map(string)
  default = {
    caller            = "$context.identity.caller"
    extendedRequestId = "$context.extendedRequestId"
    httpMethod        = "$context.httpMethod"
    ip                = "$context.identity.sourceIp"
    protocol          = "$context.protocol"
    requestId         = "$context.requestId"
    requestTime       = "$context.requestTime"
    resourcePath      = "$context.resourcePath"
    responseLength    = "$context.responseLength"
    status            = "$context.status"
    user              = "$context.identity.user"
    errorMessage      = "$context.error.messageString"
  }
}

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

variable "openapi_json" {
  type    = string
  default = null
}

# source: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-swagger-extensions-integration.html
variable "integrations" {
  type = map(map(object({
    uri                  = optional(string) # Required for all types, except MOCK
    type                 = optional(string, "AWS_PROXY")
    httpMethod           = optional(string, "POST") # integration method. For Lambda function invocations, the value must be POST
    payloadFormatVersion = optional(string, "2.0")
    requestParameters    = optional(map(string))
    requestTemplates     = optional(map(string))
    responses = optional(map(object({
      statusCode        = string
      responseTemplates = optional(map(any))
      methodResponseContent = optional(map(object({
        schema = object({
          type       = string
          properties = optional(any)
        })
      })))
    })))

    cacheKeyParameters  = optional(list(string))
    cacheNamespace      = optional(string)
    connectionId        = optional(string)
    connectionType      = optional(string)
    credentials         = optional(string)
    contentHandling     = optional(string)
    integrationSubtype  = optional(string)
    passthroughBehavior = optional(string)
    timeoutInMillis     = optional(number)
    tlsConfig = optional(object({
      insecureSkipVerification = optional(bool, true)
      serverNameToVerify       = optional(string)
    }))
  })))

  description = "API Gateway integration OpenAPI object. Example: {path: {http_method: {<property_name>: <property_value>}}}"
  default     = {}

  # Params validations

  validation {
    condition = alltrue([
      for p, methods in var.integrations : alltrue([
        for _, params in methods : contains(["VPC_LINK", "INTERNET"], params["connectionType"]) if params["connectionType"] != null
      ])
    ])
    error_message = "Bad value 'connectionType'"
  }

  validation {
    condition = alltrue([
      for p, methods in var.integrations : alltrue([
        for _, params in methods : contains(["CONVERT_TO_TEXT", "CONVERT_TO_BINARY"], params["contentHandling"]) if params["contentHandling"] != null
      ])
    ])
    error_message = "Bad value 'contentHandling'"
  }

  validation {
    condition = alltrue([
      for p, methods in var.integrations : alltrue([
        for _, params in methods : contains(["POST", "GET", "PUT", "DELETE", "HEAD", "OPTIONS", "PATCH"], upper(params["httpMethod"]))
      ])
    ])
    error_message = "Bad value 'httpMethod'"
  }

  validation {
    condition = alltrue([
      for p, methods in var.integrations : alltrue([
        for _, params in methods : contains(["1.0", "2.0"], params["payloadFormatVersion"])
      ])
    ])
    error_message = "Bad value 'payloadFormatVersion'"
  }

  validation {
    condition = alltrue([
      for p, methods in var.integrations : alltrue([
        for _, params in methods : (50 < params["timeoutInMillis"] && params["timeoutInMillis"] < 29000) if params["timeoutInMillis"] != null
      ])
    ])
    error_message = "Bad value 'timeoutInMillis'"
  }

  validation {
    condition = alltrue([
      for p, methods in var.integrations : alltrue([
        for _, params in methods : contains(["AWS_PROXY", "AWS", "HTTP", "HTTP_PROXY", "MOCK"], params["type"])
      ])
    ])
    error_message = "Bad value 'type'"
  }

  validation {
    condition = alltrue([
      for p, methods in var.integrations : alltrue([
        for _, params in methods : (params["uri"] != null) if upper(params["type"]) != "MOCK"
      ])
    ])
    error_message = "Param 'uri' is required for all types, except MOCK"
  }

  # Params type-specific validations

  validation {
    condition = alltrue([
      for p, methods in var.integrations : alltrue([
        for _, params in methods : (params["httpMethod"] == "POST") if upper(params["type"]) == "AWS_PROXY"
      ])
    ])
    error_message = "For Lambda function invocations: 'httpMethod' must be 'POST', 'uri' must be provided and 'type' must be 'AWS_PROXY'"
  }
}

variable "add_integration_health_route" {
  type    = bool
  default = false
}

variable "responses" {
  type = map(object({
    statusCode        = string
    responseTemplates = map(string)
  }))
  default = {
    "DEFAULT_4XX" = {
      statusCode = "403"
      responseTemplates = {
        "application/json" = "{\"message\": \"Access denied\"}"
      }
    },
    "MISSING_AUTHENTICATION_TOKEN" = {
      statusCode = "404"
      responseTemplates = {
        "application/json" = "{\"message\": \"Not found\"}"
      }
    }
  }
}

variable "stage_method_settings" {
  type = map(object({
    caching_enabled      = optional(bool, false)
    cache_data_encrypted = optional(bool, true)
    metrics_enabled      = optional(bool, false)
    logging_level        = optional(string, "OFF")
    method_path          = optional(string, "*/*")
    data_trace_enabled   = optional(bool, false)
    throttling_burst     = optional(number, -1)
    throttling_rate      = optional(number, -1)
  }))
  default = {}
}

variable "stage_cache_enabled" {
  type    = bool
  default = false
}

variable "stage_xray_tracing_enabled" {
  type    = bool
  default = false
}

variable "stage_variables" {
  type    = map(string)
  default = {}
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

variable "use_strict_lambda_permissions" {
  type        = bool
  description = "Whether to use strict lambda permissions or not. If true, the only related stage will be able to invoke lambda function. Otherwise, ANY could, which is needed for testing using Test button in AWS Console (it uses 'test-invoke-stage' stage)."
  default     = true
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

#-------------------------------------#
# Tags

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to all resources"
}

variable "apig_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the API Gateway resource only"
}

variable "stage_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the API Gateway stage resource only"
}

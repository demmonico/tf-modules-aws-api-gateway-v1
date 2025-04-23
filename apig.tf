#-------------------------------------#
# API Gateway

resource "aws_api_gateway_rest_api" "this" {
  name = var.api_name

  endpoint_configuration {
    types = [var.api_endpoint_type]
  }

  body = var.openapi_json != null ? var.openapi_json : jsonencode({
    openapi = "3.0.1"
    info = {
      title   = var.api_name
      version = "1.0"
    }

    paths = {
      for path, methods in var.integrations : path => {
        for httpMethod, params in methods : lower(httpMethod) => {
          responses = { for k, v in(can(params["responses"]) ? params["responses"] : {}) : v["statusCode"] => {
            content     = v["methodResponseContent"]
            description = k
          } if v["methodResponseContent"] != null }
          x-amazon-apigateway-integration = { for k, v in params : k => v if v != null }
        }
      }
    }

    x-amazon-apigateway-gateway-responses = var.responses
  })

  lifecycle {
    precondition {
      condition     = var.openapi_json != null || length(var.integrations) > 0
      error_message = "Either 'openapi_json' or 'integrations' must be provided."
    }
    create_before_destroy = true
  }

  tags = merge(local.tags, var.apig_tags)
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(setunion(
      [aws_api_gateway_rest_api.this.body],
      var.create_lambda_permissions ? [
        for name in var.lambda_permission_names_list : aws_lambda_permission.lambda_perm[name].source_arn
      ] : [],
      var.create_whitelist_api_resource_policy ? [aws_api_gateway_rest_api_policy.internal[0].policy] : [],
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name

  dynamic "access_log_settings" {
    for_each = var.cw_logs_enabled ? [1] : []

    content {
      destination_arn = var.create_cw_log_group ? aws_cloudwatch_log_group.access_logs[0].arn : var.cw_log_group_arn
      format          = jsonencode(var.cw_logs_format)
    }
  }

  cache_cluster_enabled = var.stage_cache_enabled
  xray_tracing_enabled  = var.stage_xray_tracing_enabled

  tags = merge(local.tags, var.stage_tags)
}

resource "aws_api_gateway_method_settings" "this" {
  for_each = var.stage_method_settings

  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = each.value["method_path"]

  settings {
    caching_enabled        = each.value["caching_enabled"]
    cache_data_encrypted   = each.value["cache_data_encrypted"]
    metrics_enabled        = each.value["metrics_enabled"]
    logging_level          = each.value["logging_level"]
    data_trace_enabled     = each.value["data_trace_enabled"]
    throttling_burst_limit = each.value["throttling_burst_limit"]
    throttling_rate_limit  = each.value["throttling_rate_limit"]
  }
}

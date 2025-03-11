locals {
  api_path_map = tomap({
    for op in var.paths : op.path => op
  })
  gateway_responses_map = tomap({
    for or in var.gateway_responses : or.key => or
  })
}

#-------------------------------------#
# API Gateway

resource "aws_api_gateway_rest_api" "this" {
  name = var.api_name

  endpoint_configuration {
    types = [var.api_endpoint_type]
  }

  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = var.api_name
      version = "1.0"
    }

    paths = {
      for path, op in local.api_path_map : path => {
        lower(coalesce(op.http_method, "get")) = {
          x-amazon-apigateway-integration = {
            uri                  = op.integration_uri
            type                 = upper(coalesce(op.integration_type, "AWS_PROXY"))
            httpMethod           = upper(coalesce(op.integration_method, "POST"))
            payloadFormatVersion = upper(coalesce(op.payload_version, "2.0"))
          }
        }
      }
    }

    x-amazon-apigateway-gateway-responses = {
      for key, resp in local.gateway_responses_map : key => {
        statusCode        = resp.status_code
        responseTemplates = resp.templates
      }
    }
  })
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
}

# API Gateway Outputs

output "apig_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "apig_arn" {
  value = aws_api_gateway_rest_api.this.arn
}

output "apig_execution_arn" {
  value = aws_api_gateway_rest_api.this.execution_arn
}

output "deployment_id" {
  value = aws_api_gateway_deployment.this.id
}

output "stage_invoke_url" {
  value = aws_api_gateway_stage.this.invoke_url
}

output "stage_execution_arn" {
  value = aws_api_gateway_stage.this.execution_arn
}

# IAM Outputs

output "iam_lambda_permissions" {
  value = {
    for perm in aws_lambda_permission.lambda_perm : perm.function_name => {
      id            = perm.id
      function_name = perm.function_name
      source_arn    = perm.source_arn
    }
  }
}

# Custom Domain Outputs

output "cw_log_group_name" {
  value = local.log_group_name
}

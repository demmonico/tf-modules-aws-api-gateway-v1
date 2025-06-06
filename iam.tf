locals {
  lambda_permission_names_list = var.create_lambda_permissions ? var.lambda_permission_names_list : []
}

#-------------------------------------#
# IAM Role

resource "aws_lambda_permission" "lambda_perm" {
  for_each = toset(local.lambda_permission_names_list)

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/${var.use_strict_lambda_permissions ? var.stage_name : "*"}/*"
}

data "aws_iam_policy_document" "internal" {
  count = var.create_whitelist_api_resource_policy ? 1 : 0

  statement {
    effect    = "Deny"
    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.this.execution_arn}/*/*/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = var.whitelist_ip_cidrs
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.this.execution_arn}/*/*/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
resource "aws_api_gateway_rest_api_policy" "internal" {
  count = var.create_whitelist_api_resource_policy ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.this.id
  policy      = data.aws_iam_policy_document.internal[0].json
}

resource "aws_api_gateway_rest_api_policy" "extra" {
  for_each = toset(var.attach_iam_policies)

  rest_api_id = aws_api_gateway_rest_api.this.id
  policy      = jsonencode(each.value)
}

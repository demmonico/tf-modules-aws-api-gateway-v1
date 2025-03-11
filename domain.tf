#-------------------------------------#
# Domain

resource "aws_api_gateway_domain_name" "this" {
  count = var.create_custom_domain ? 1 : 0

  domain_name              = var.custom_domain
  regional_certificate_arn = var.custom_domain_cert_arn
  security_policy          = var.custom_domain_security_policy

  endpoint_configuration {
    types = [var.custom_domain_endpoint_type]
  }
}

resource "aws_route53_record" "this" {
  count = var.create_custom_domain ? 1 : 0

  zone_id = var.custom_domain_zone_id
  name    = aws_api_gateway_domain_name.this[0].domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.this[0].regional_domain_name
    zone_id                = aws_api_gateway_domain_name.this[0].regional_zone_id
    evaluate_target_health = false
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count = var.create_custom_domain ? 1 : 0

  domain_name = aws_api_gateway_domain_name.this[0].id
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = var.stage_name

  depends_on = [
    aws_api_gateway_stage.this
  ]
}

locals {
  log_group_name = var.cw_log_group_name != "" ? var.cw_log_group_name : "/aws/api-gateway/${var.api_name}/access_logs"
}

#-------------------------------------#
# Log group

resource "aws_cloudwatch_log_group" "access_logs" {
  count = var.cw_logs_enabled && var.create_cw_log_group ? 1 : 0

  name              = local.log_group_name
  retention_in_days = var.cw_logs_retention
}

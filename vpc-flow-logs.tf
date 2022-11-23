######################################################
# VPC Flow Logs
######################################################

resource "aws_cloudwatch_log_group" "jenkins" {
  count = var.enable_flow_logs ? 1 : 0

  name              = "${var.name}-flowlogs"
  
  retention_in_days = var.cloudwatch_flowlog_retention
  kms_key_id        = aws_kms_key.jenkins[count.index].id
}

resource "aws_kms_key" "jenkins" {
  count = var.enable_flow_logs ? 1 : 0

  description             = "Manages ${var.name} encryption"
  deletion_window_in_days = 10

  multi_region = false

  tags = merge(
    { "Name" = "${var.name}-kms" },
    { "VPC" = var.name }
  )

}


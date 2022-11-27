######################################################
# VPC Flow Logs
######################################################

resource "aws_cloudwatch_log_group" "main" {
  count = var.enable_flow_logs ? 1 : 0

  name              = "${var.name}-flowlogs"
  retention_in_days = var.cloudwatch_flowlog_retention
  kms_key_id        = aws_kms_key.main[count.index].arn

  tags = merge({
    "Name"        = "${var.name}",
    "Environment" = var.environment
  })
}

resource "aws_kms_key" "main" {
  count = var.enable_flow_logs ? 1 : 0

  description              = "Manages encryption for the ${var.name}-vpc"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  multi_region             = false
  is_enabled               = true
  enable_key_rotation      = true
  policy                   = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "logs.${var.region}.amazonaws.com"
      },
      "Action": [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ],
      "Resource": "*",
      "Condition": {
        "ArnLike": {
          "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${var.region}:${var.account_id}:log-group:${var.name}-flowlogs"
        }
      }
    }
  ]
}
  EOF

  tags = merge({
    "Name"        = "${var.name}",
    "Environment" = var.environment
  })
}

resource "aws_kms_alias" "main" {
  count = var.enable_flow_logs ? 1 : 0

  name          = "alias/${var.name}-vpc"
  target_key_id = aws_kms_key.main[count.index].key_id
}

resource "aws_iam_role" "main" {
  count = var.enable_flow_logs ? 1 : 0

  name        = "${var.name}-vpc-flowlogs"
  description = "Provides the necessary access to enable ${var.name}-vpc flowlogs"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "vpc-flow-logs.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  } 
  EOF

  tags = merge({
    "Name"        = "${var.name}-vpc-flowlogs",
    "Environment" = var.environment
  })
}

resource "aws_iam_role_policy" "main" {
  count = var.enable_flow_logs ? 1 : 0

  name = "${var.name}-vpc-flowlogs-policy"
  role = aws_iam_role.main[count.index].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:${var.region}:${var.account_id}:log-group:*"
    }
  ]
}
  EOF

}

resource "aws_flow_log" "main" {
  count = var.enable_flow_logs ? 1 : 0

  iam_role_arn             = aws_iam_role.main[count.index].arn
  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.main[count.index].arn
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.main.id
  max_aggregation_interval = "60"

  tags = merge(
    { "Name" = "${var.name}-vpc-flowlogs" },
    { "VPC" = var.name }
  )
}

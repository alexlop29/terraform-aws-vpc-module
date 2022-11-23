######################################################
# VPC Flow Logs
######################################################

resource "aws_cloudwatch_log_group" "flowlogs" {
  count = var.enable_flow_logs ? 1 : 0

  name              = "${var.name}-flowlogs"
  retention_in_days = var.cloudwatch_flowlog_retention
  kms_key_id        = aws_kms_key.main[count.index].arn
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
  policy = <<EOF
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
                "ArnEquals": {
                    "kms:EncryptionContext:aws:logs:arn": "${aws_cloudwatch_log_group.flowlogs[count.index].arn}"
                }
            }
        } 
    ]
  }
  EOF

  tags = merge(
    { "Name" = "${var.name}-vpc-kms" },
    { "VPC" = var.name }
  )
}

resource "aws_kms_alias" "main" {
  count = var.enable_flow_logs ? 1 : 0

  name          = "alias/${var.name}-vpc"
  target_key_id = aws_kms_key.main[count.index].key_id
}

resource "aws_iam_role" "flowlogs" {
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

  tags = merge(
    { "Name" = "${var.name}-vpc-flowlogs" },
    { "VPC" = var.name }
  )

}

resource "aws_iam_role_policy" "flowlogs" {
  count = var.enable_flow_logs ? 1 : 0

  name = "${var.name}-vpc-flowlogs-policy"
  role = aws_iam_role.flowlogs[0].id

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
        "Resource": "${replace(aws_cloudwatch_log_group.flowlogs[count.index].arn, ":*", "")}:*"
      }
    ]
  }
  EOF

}

resource "aws_flow_log" "flowlogs" {
  count = var.enable_flow_logs ? 1 : 0

  iam_role_arn             = aws_iam_role.flowlogs[count.index].arn
  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.flowlogs[count.index].arn
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.main.id
  max_aggregation_interval = "60"
  destination_options {
    file_format        = "parquet"
    per_hour_partition = true
  }

  tags = merge(
    { "Name" = "${var.name}-vpc-flowlogs" },
    { "VPC" = var.name }
  )
}

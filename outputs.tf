output "vpc_id" {
  value       = join("", aws_vpc.main.*.id)
  description = "The ID of the VPC"
}

output "vpc_arn" {
  value       = join("", aws_vpc.main.*.arn)
  description = "Amazon Resource Name (ARN) of VPC"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "vpc_arn" {
  value       = aws_vpc.main.arn
  description = "Amazon Resource Name (ARN) of the VPC"
}

output "vpc_private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "vpc_public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

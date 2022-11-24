################################################################
# VPC
################################################################

variable "ipv4_primary_cidr_block" {
  type        = string
  description = <<-EOT
    The IPv4 CIDR block for the VPC.
  EOT
  default     = null
}

variable "instance_tenancy" {
  type        = string
  description = <<-EOT
    A tenancy option for instances launched into the VPC
  EOT
  default     = "default"
}

variable "enable_dns_support" {
  type        = bool
  description = <<-EOT
    A boolean flag to enable/disable DNS support in the VPC
  EOT
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = <<-EOT
   A boolean flag to enable/disable DNS hostnames in the VPC
  EOT
  default     = false
}

variable "name" {
  type        = string
  description = <<-EOT
    Name to be used on all the resources as identifier
  EOT
  default     = ""
}

variable "environment" {
  type        = string
  description = <<-EOT
    Environment in which this network resides (e.g. dev/prod)
  EOT
  default     = "dev"
}

################################################################
# Public Subnet
################################################################

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets"
  type        = string
  default     = "public"
}

variable "public_inbound_acl_rules" {
  description = "Public subnets inbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_outbound_acl_rules" {
  description = "Public subnets outbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

################################################################
# Private Subnet
################################################################

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_inbound_acl_rules" {
  description = "Private subnets inbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_outbound_acl_rules" {
  description = "Private subnets outbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

################################################################
# VPC Flow Logs
################################################################

variable "enable_flow_logs" {
  description = "Whether or not to build flow log components in Cloudwatch Logs"
  default     = false
  type        = bool
}

variable "cloudwatch_flowlog_retention" {
  description = "The number of days to retain flowlogs in CLoudwatch Logs"
  type        = number
  default     = 14
}

variable "account_id" {
  description = "Provide the AWS account number"
  type        = string
  default     = ""
}

variable "region" {
  description = "Provide the desired region"
  type        = string
  default     = ""
}

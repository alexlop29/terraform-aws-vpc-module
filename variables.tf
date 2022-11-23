variable "ipv4_primary_cidr_block" {
  type        = string
  description = <<-EOT
    (Optional) The IPv4 CIDR block for the VPC. 
    CIDR can be explicitly set 
    or it can be derived from IPAM using ipv4_netmask_length
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

variable "enable_dns_hostnames" {
  type        = bool
  description = <<-EOT
   A boolean flag to enable/disable DNS hostnames in the VPC
  EOT
  default     = false
}

variable "enable_dns_support" {
  type        = bool
  description = <<-EOT
    A boolean flag to enable/disable DNS support in the VPC
  EOT
  default     = true
}

variable "name" {
  type        = string
  description = <<-EOT
    Name to be used on all the resources as identifier
  EOT
  default     = ""
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
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

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
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

variable "nat_gateway_destination_cidr_block" {
  description = "Used to pass a custom destination route for private NAT Gateway. If not specified, the default 0.0.0.0/0 is used as a destination route."
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_flow_logs" {
  description = "Whether or not to build flow log components in Cloudwatch Logs"
  default     = true
  type        = bool
}

variable "cloudwatch_flowlog_retention" {
  description = "The number of days to retain flowlogs in CLoudwatch Logs. Valid values are: [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]. A value of `0` will retain indefinitely."
  type        = number
  default     = 14
}

variable "account_id" {
  description = "Provide the account number of an AWS"
  type        = string
  default     = "748954057513"
}

variable "region" {
  description = "Provide the desired region"
  type        = string
  default     = ""
}

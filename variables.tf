variable "use_ipam_pool" {
  type        = bool
  description = <<-EOT
    Set to true to enable IPAM for CIDR allocation
  EOT
  default     = false
}

variable "ipv4_primary_cidr_block" {
  type        = string
  description = <<-EOT
    (Optional) The IPv4 CIDR block for the VPC. 
    CIDR can be explicitly set 
    or it can be derived from IPAM using ipv4_netmask_length
  EOT
  default     = null
}

variable "ipv4_ipam_pool_id" {
  type        = string
  description = <<-EOT
    (Optional) The ID of an IPv4 IPAM pool you want 
    to use for allocating this VPC's CIDR.
  EOT
  default     = null
}

variable "ipv4_netmask_length" {
  type        = number
  description = <<-EOT
    (Optional) The netmask length of the IPv4 CIDR you 
    want to allocate to this VPC. 
    Requires specifying a ipv4_ipam_pool_id.
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

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_tags" {
  type        = map(string)
  description = "Additional tags for the VPC"
  default     = {}
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
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

variable "create_vpc" {
  type        = bool
  description = <<-EOT
    Set to `true` to enable VPC creation"
  EOT
  default     = true
}

variable "ipv4_primary_cidr_block" {
  type        = string
  description = <<-EOT
    Define the IPv4 CIDR block for the VPC
    NOTE: (alopez) This value can also be dervied from IPAM.
  EOT
  default     = null
}

variable "use_ipam_pool" {
  type        = bool
  description = <<-EOT 
    Set to `true` to enable IPAM for CIDR allocation
  EOT
  default     = false
}

variable "ipv4_ipam_pool_id" {
  type        = string
  description = <<-EOT
    Define the ID of an IPv4 IPAM pool to use for CIDR allocation
  EOT
  default     = null
}

variable "ipv4_netmask_length" {
  type        = number
  description = <<-EOT
    Specify the netmask length of the IPv4 CIDR
    NOTE: (alopez) Use in tandem with ipv4_ipam_pool_id
  EOT
  default     = null
}

variable "enable_ipv6" {
  type        = bool
  description = <<-EOT
  Set to `true` to request an Amazon-provided IPv6 CIDR block with a /56 prefix length
  EOT
  default     = false
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "private_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "public_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

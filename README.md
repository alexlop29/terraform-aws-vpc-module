# terraform-aws-vpc

# Security & Compliance

# Examples

# Requirements

| Name | Version |
| - | - |
| terraform | >= 1.3.4 |
| aws | >= 4.39.0 |

# Providers

| Name | Version |
| - | - |
| aws | >= 4.39.0 |


# Modules
(None)

# Resources

| Name | Type |
| - | - |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |


# Inputs
| Name | Description | Type | Default | Required |
| - | - | - | - | - |
| create_vpc | Set to true to enable VPC creation | bool | true | no |
| use_ipam_pool | Set to true to enable IPAM for CIDR allocation | bool | false | no |
| ipv4_primary_cidr_block | The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length | string | null | no |
| ipv4_ipam_pool_id | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | string | null | no |
| ipv4_netmask_length | The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4_ipam_pool_id. | number | null | no |
| enable_ipv6 | Set to true to request an Amazon-provided IPv6 CIDR block with a /56 prefix length | boolean | false | no |
| ipv6_cidr | IPv6 CIDR block to request from an IPAM Pool. Can be set explicitly or derived from IPAM using ipv6_netmask_length | string | null | no |
| ipv6_ipam_pool_id |  IPAM Pool ID for a IPv6 pool. Conflicts with assign_generated_ipv6_cidr_block | string | null | no |
| ipv6_netmask_length | Netmask length to request from IPAM Pool. Conflicts with ipv6_cidr_block. This can be omitted if IPAM pool as a allocation_default_netmask_length set. Valid values: 56 | number | null | no |
| instance_tenancy | A tenancy option for instances launched into the VPC | string | default | no |
| enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC | boolean | false | no |
| enable_dns_support | A boolean flag to enable/disable DNS support in the VPC | boolean | true | no |
| name | Name to be used on all the resources as identifier | string | "" | no |
| tags | A map of tags to add to all resources | map(string) | {} | no |
| vpc_tags | Additional tags for the VPC | map(string) | {} | no |

# Outputs

# License
See LICENSE for full details. 

# About

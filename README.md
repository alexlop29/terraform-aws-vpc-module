# terraform-aws-vpc

## Scope
- `terraform-aws-vpc` aides in provisioning an IPv4-based VPC. It does not provide the necessary functionality to build an IPv6-based VPC. The feature can be included upon request.

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
| [aws_default_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_default_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |

# Inputs
| Name | Description | Type | Default | Required |
| - | - | - | - | - |
| create_vpc | Set to true to enable VPC creation | bool | true | no |
| use_ipam_pool | Set to true to enable IPAM for CIDR allocation | bool | false | no |
| ipv4_primary_cidr_block | The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length | string | null | no |
| ipv4_ipam_pool_id | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | string | null | no |
| ipv4_netmask_length | The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4_ipam_pool_id. | number | null | no |
| instance_tenancy | A tenancy option for instances launched into the VPC | string | default | no |
| enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC | boolean | false | no |
| enable_dns_support | A boolean flag to enable/disable DNS support in the VPC | boolean | true | no |
| name | Name to be used on all the resources as identifier | string | "" | no |
| tags | A map of tags to add to all resources | map(string) | {} | no |
| vpc_tags | Additional tags for the VPC | map(string) | {} | no |

# Outputs
| Name | Description |
| - | - |
| vpc_id | The ID of the VPC |
| vpc_arn | Amazon Resource Name (ARN) of VPC |

# License
See LICENSE for full details. 

# Notes from Alex
- Follows best practices regarding Security Groups (SGs); See https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#securityhub-cis-controls-4.3

- Go back and add version specific docs in resources

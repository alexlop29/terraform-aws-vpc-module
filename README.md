# Notes from Alex

- Include helpful outputs

- Come back and check https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#securityhub-cis-controls-4.3; 
  - Run Sec Checks

Working on:
- Updating the tagging strategy
- As I tag, I will review the configuration and compare the sec checks / terraform guidelines
- Update variables
- Deploy basic vpc
- Write a note on the tagging strategy in the module

LEFT OFF UDPATING THE VPC FLOW LOGS TF

NOTE:
- Unable to set VPC Flow Logs
- NOTE: (alopez) Potential Bug; What if a user specifies 3 subnets, 2 AZs.

# Testing
- Deployed VPC, Deployed EC2 in the Public Subnet, Testing Reachability and Routing via Reachability Analyzer
  - Provide screen captures of successfully reaching the public instance, blocked access to the private instance even with a public ip

# terraform-aws-vpc

- [terraform-aws-vpc](#terraform-aws-vpc)
  * [Scope](#scope)
  * [Security & Compliance](#security---compliance)
- [Examples](#examples)
- [Requirements](#requirements)
  * [Providers](#providers)
  * [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [License](#license)

## Scope
- `terraform-aws-vpc` aides in provisioning an IPv4-based VPC. It does not provide the necessary functionality to build an IPv6-based VPC. The feature can be included upon request.
- `terraform-aws-vpc` does not support IPAM. The feature can be included upon request.
- `terraform-aws-vpc` provides access to CloudWatch flow logs. Configuring extended storage to S3 requires a `terraform-aws-s3` module. The feature will be included in a later release.
- `terraform-aws-vpc` does not include automated alerting of KMS keys (e.g. monitoring the key rotation process, )

## Security & Compliance
- Follows best practices regarding Security Groups (SGs); See https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#securityhub-cis-controls-4.3
- Each subnet in your VPC must be associated with a network ACL. If you don't explicitly associate a subnet with a network ACL, the subnet is automatically associated with the default network ACL. - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html
- Each NAT gateway is created in a specific Availability Zone and implemented with redundancy in that zone. There is a quota on the number of NAT gateways that you can create in each Availability Zone. For more information, see Amazon VPC quotas.
  - If you have resources in multiple Availability Zones and they share one NAT gateway, and if the NAT gateway’s Availability Zone is down, resources in the other Availability Zones lose internet access. 
- Encryption at rest - AWS KMS generates key material for AWS KMS keys in FIPS 140-2 Level 2–compliant hardware security modules (HSMs).
  - See https://docs.aws.amazon.com/kms/latest/developerguide/kms-compliance.html for additional details regarding SOC2 reports.
  - SYMMETRIC_DEFAULT currently represents AES-256-GCM, a symmetric algorithm based on Advanced Encryption Standard (AES) in Galois Counter Mode (GCM) with 256-bit keys, an industry standard for secure encryption. 
- Network Address Usage (NAU) is a metric applied to resources in your virtual network to help you plan for and monitor the size of your VPC. There is no cost to monitor NAU. 


# Examples

# Requirements

| Name | Version |
| - | - |
| terraform | >= 1.3.4 |
| aws | >= 4.39.0 |

## Providers

| Name | Version |
| - | - |
| aws | >= 4.39.0 |


## Modules
(None)

# Resources

| Name | Type |
| - | - |
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_default_network_acl](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/default_network_acl) | resource |
| [aws_default_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/default_route_table) | resource |
| [aws_default_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/default_security_group) | resource |
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/eip) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/nat_gateway) | resource|
| [aws_network_acl](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/network_acl) | resource |
| [aws_network_acl_rule](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/network_acl_rule) | resource |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route_table) | resource |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route_table_association) | resource |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/subnet) | resource |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/vpc) | resource |

# Inputs
| Name | Description | Type | Default | Required |
| - | - | - | - | - |
| ipv4_primary_cidr_block | The IPv4 CIDR block for the VPC | string | null | yes |
| instance_tenancy | A tenancy option for instances launched into the VPC | string | default | no |
| enable_dns_support | A boolean flag to enable/disable DNS support in the VPC | boolean | true | no |
| enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC | boolean | false | no |
| name | Name to be used on all the resources as identifier | string | "" | yes |
| environment | Environment in which this network resides (e.g. dev/prod) | string | "dev" | no |
| public_subnet_suffix | Suffix to append to public subnets | string | "public" | no |
| public_subnets | A list of public subnets inside the VPC | list(string) | [] | yes |
| public_inbound_acl_rules | Public subnets inbound network ACLs | list(map(string)) | [{ all inbound}]| no |
| public_outbound_acl_rules | Public subnets outbound network ACLs | list(map(string)) | [{ all outbound}]| no |
| azs | A list of availability zones names or ids in the region | list(string) | [] | yes |
| private_subnet_suffix | Suffix to append to private subnets | string | "private" | no |
| private_subnets | A list of private subnets inside the VPC | list(string) | [] | no |
| private_inbound_acl_rules | Private subnets inbound network ACLs | list(map(string)) | [{ all inbound}]| yes |
| private_outbound_acl_rules | Private subnets outbound network ACLs | list(map(string)) | [{ all inbound}]| no |
| enable_flow_logs | Whether or not to build flow log components in Cloudwatch Logs | bool | true | no |
| cloudwatch_flowlog_retention | The number of days to retain flowlogs in CLoudwatch Logs | number | 14 | no |
| account_id | Provide the AWS account number | string | "" | yes |
| region | Provide the desired region | string | "" | yes |
 
# Outputs
| Name | Description |
| - | - |
| vpc_id | The ID of the VPC |
| vpc_arn | Amazon Resource Name (ARN) of VPC |

# License
Refer to LICENSE for additional details.

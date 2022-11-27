# Notes from Alex
- Working on Flow Logs Error
- Add Checkov, Dependabot Checks; noT WORKING COULD BE DUE TO MAIN FILE
- Add security and compliance config

# terraform-aws-vpc

# Security & Compliance


# Examples
```
module "vpc" {
  source = "../../"

  name                    = "prod"
  ipv4_primary_cidr_block = "192.168.2.0/24"
  azs                     = ["us-east-2a", "us-east-2b"]
  public_subnets          = ["192.168.2.0/26", "192.168.2.64/26"]
  private_subnets         = ["192.168.2.128/26", "192.168.2.192/26"]
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_flow_logs        = true
  region                  = "us-east-2"
  account_id              = "123456789000"
}
```

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
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/aws_iam_role_policy) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/internet_gateway) | resource |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/kms_key) | resource |
| [aws_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/kms_alias) | resource |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/nat_gateway) | resource|
| [aws_network_acl](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/network_acl) | resource |
| [aws_network_acl_rule](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/network_acl_rule) | resource |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route_table) | resource |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route_table_association) | resource |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/subnet) | resource |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/vpc) | resource |
| [aws_flow_log](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/flow_log) | resource |

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
| private_subnets | A list of private subnets inside the VPC | list(string) | [] | yes |
| private_inbound_acl_rules | Private subnets inbound network ACLs | list(map(string)) | [{ all inbound}]| no |
| private_outbound_acl_rules | Private subnets outbound network ACLs | list(map(string)) | [{ all inbound}]| no |
| enable_flow_logs | Whether or not to build flow log components in Cloudwatch Logs | bool | false | no |
| cloudwatch_flowlog_retention | The number of days to retain flowlogs in CLoudwatch Logs | number | 14 | no |
| account_id | Provide the AWS account number | string | "" | no |
| region | Provide the desired region | string | "" | no |
 
# Outputs
| Name | Description |
| - | - |
| vpc_id | ID of the VPC |
| vpc_arn | Amazon Resource Name (ARN) of VPC |
| vpc_private_subnets | List of IDs of private subnets |
| vpc_public_subnets | List of IDs of public subnets |

# License
Refer to LICENSE for additional details.

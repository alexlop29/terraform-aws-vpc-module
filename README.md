# terraform-aws-vpc

## Scope
- `terraform-aws-vpc` aides in provisioning an IPv4-based VPC. It does not provide the necessary functionality to build an IPv6-based VPC. The feature can be included upon request.
- `terraform-aws-vpc` does not support IPAM. The feature can be included upon request.

# Security & Compliance
- Follows best practices regarding Security Groups (SGs); See https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#securityhub-cis-controls-4.3
- Each subnet in your VPC must be associated with a network ACL. If you don't explicitly associate a subnet with a network ACL, the subnet is automatically associated with the default network ACL. - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html
- Each NAT gateway is created in a specific Availability Zone and implemented with redundancy in that zone. There is a quota on the number of NAT gateways that you can create in each Availability Zone. For more information, see Amazon VPC quotas.
  - If you have resources in multiple Availability Zones and they share one NAT gateway, and if the NAT gateway’s Availability Zone is down, resources in the other Availability Zones lose internet access. 

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
| [aws_default_network_acl](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/default_network_acl) | resource |
| [aws_network_acl](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/network_acl) | resource |
| [aws_network_acl_rule](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/network_acl_rule) | resource |
| [aws_default_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/default_route_table) | resource |
| [aws_default_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/default_security_group) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/internet_gateway) | resource |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route_table) | resource |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route_table_association) | resource |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/subnet) | resource |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/vpc) | resource |

# Inputs
| Name | Description | Type | Default | Required |
| - | - | - | - | - |
| name | Name to be used on all the resources as identifier | string | "" | no |
| ipv4_primary_cidr_block | The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length | string | null | no |
| instance_tenancy | A tenancy option for instances launched into the VPC | string | default | no |
| enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC | boolean | false | no |
| enable_dns_support | A boolean flag to enable/disable DNS support in the VPC | boolean | true | no |
| azs | A list of availability zones names or ids in the region | list(string) | [] | no |
| public_subnets | A list of public subnets inside the VPC | list(string) | [] | no |
| private_subnets | A list of private subnets inside the VPC | list(string) | [] | no |
| public_inbound_acl_rules | Public subnets inbound network ACLs | list(map(string)) | [{ all inbound}]| no |
| public_outbound_acl_rules | Public subnets outbound network ACLs | list(map(string)) | [{ all inbound}]| no |
| private_inbound_acl_rules | Private subnets inbound network ACLs | list(map(string)) | [{ all inbound}]| no |
| private_outbound_acl_rules | Private subnets outbound network ACLs | list(map(string)) | [{ all inbound}]| no |
 
 
# Outputs
| Name | Description |
| - | - |
| vpc_id | The ID of the VPC |
| vpc_arn | Amazon Resource Name (ARN) of VPC |

# License
See LICENSE for full details. 

# Recommended Reading
- [AWS Documentation: Route Tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)

# Notes from Alex

- Add VPC Flow Logs

- Test connectivity with AWS EC2 SSM Enabled Instance

- Include helpful outputs

- AWS' reachability analyzer discovered an error due to the deny in the default NACL. 

- Link back to diagram / https://lucid.app/lucidchart/b4945319-bd0b-4e32-a951-05d4af86ac2e/edit?invitationId=inv_f2194271-1614-42b6-8210-084039d2e2e8&page=0_0#
  - Add NAT config to diagram

- Restructure and organize the resources in main

LEFT OFF OBTAINING ACCESS TO EC2 ---> SSM ACCESS / NEED TO RUN THROUGH REACHABILITY ANALYZER
-DOES THE NAT GATEWAY HAVE TO BE ADDED TO THE ROUTING TABLE
- MUST RECONFIGURE ROUTE TABLE TO ACCESS THE NAT GATEWAYS
- Contains examples on fixing the routing tables ---> https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-scenarios.html

- Come back and check https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#securityhub-cis-controls-4.3; 
  - Run Sec Checks


Consider adding a local CIDR route to the routing tables. See https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-scenarios.html. 

# Testing
- Deployed VPC, Deployed EC2 in the Public Subnet, Testing Reachability and Routing via Reachability Analyzer
  - Provide screen captures of successfully reaching the public instance, blocked access to the private instance even with a public ip

# Github
- https://github.com/cloudposse/terraform-aws-vpc
- https://github.com/terraform-aws-modules/terraform-aws-vpc
- https://github.com/rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork

# Resources 
- https://aws.amazon.com/premiumsupport/knowledge-center/nat-gateway-vpc-private-subnet/


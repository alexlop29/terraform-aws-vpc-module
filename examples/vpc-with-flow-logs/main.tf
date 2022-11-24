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
  account_id              = "748954057513"
}

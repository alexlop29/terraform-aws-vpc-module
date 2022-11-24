module "vpc" {
  source = "../../"

  name                    = "dev"
  ipv4_primary_cidr_block = "192.168.3.0/24"
  azs                     = ["us-east-2a"]
  public_subnets          = ["192.168.3.0/26"]
  private_subnets         = ["192.168.3.128/26"]
  enable_dns_hostnames    = true
    
}

module "vpc" {
  source = "../../"

  # NOTE: (alopez) Specify a version when using.
  # version = "x.x.x"

  name                    = "dev"
  ipv4_primary_cidr_block = "192.168.3.0/24"

  instance_tenancy = "default"

  azs             = ["us-east-2a"]
  public_subnets  = ["192.168.3.0/26"]
  private_subnets = ["192.168.3.128/26"]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs = false

}

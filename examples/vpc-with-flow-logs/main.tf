module "vpc" {
  source = "../../"

  # NOTE: (alopez) Specify a version when using.
  # version = "x.x.x"

  name                    = "jenkins"
  ipv4_primary_cidr_block = "192.168.2.0/24"

  instance_tenancy = "default"

  azs             = ["us-east-2a", "us-east-2b"]
  public_subnets  = ["192.168.2.0/26", "192.168.2.64/26"]
  private_subnets = ["192.168.2.128/26", "192.168.2.192/26"]

  enable_dns_hostnames = true
  enable_dns_support   = true

}

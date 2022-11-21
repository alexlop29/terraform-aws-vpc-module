module "vpc" {
  source = "../../"

  # Specify a version when using.
  # version = "x.x.x"

  name                    = "jenkins"
  ipv4_primary_cidr_block = "192.168.1.0/26"

  azs             = ["us-east-2a", "us-east-2b"]
  public_subnets  = ["192.168.1.0", "192.168.1.64"]
  private_subnets = ["192.168.1.128", "192.168.1.192"]

  enable_dns_hostnames = true
  enable_dns_support   = true

}

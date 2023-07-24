module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version = "5.1.0"

  name = "${local.name}-vpc"

  cidr = local.cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "vpc-1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"
  name    = "yl-vpc-1"

  cidr             = "10.1.0.0/16"
  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  # private_subnets  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets   = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
  # database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

  enable_nat_gateway   = false  # since no private subnet
  single_nat_gateway   = false
  enable_dns_hostnames = true # needed for DNS resolution
}

module "vpc-2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"
  name    = "yl-vpc-2"

  cidr             = "10.2.0.0/16"
  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  # private_subnets  = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets   = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"]
  # database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

  enable_nat_gateway   = false # since no private subnet
  single_nat_gateway   = false
  enable_dns_hostnames = true # needed for DNS resolution
}

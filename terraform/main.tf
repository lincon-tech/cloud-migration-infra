module "vpc" {
  source = "../modules/vpc"

  vpc_cidr = var.vpc_cidr
}

module "eks" {
  source = "../modules/eks"

  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id
}
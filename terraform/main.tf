terraform {
  backend "s3" {
    bucket         = "terraform-eks-state-migproject"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    #dynamodb_table = "terraform-lock"
  }
}

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
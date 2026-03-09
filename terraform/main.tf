terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.20.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"                #CHANGE TO YOUR PREFERED REGION
}

terraform {

  backend "s3" {

    bucket         = "terraform-eks-state-migproject"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    #dynamodb_table = "terraform-lock-table"

    encrypt = true
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  
  name = "migration-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true
  
  # Tags required for EKS
  tags = {
    "kubernetes.io/cluster/migration-eks-cluster" = "shared"
  }
  
  public_subnet_tags = {
    "kubernetes.io/cluster/migration-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                     = "1"
  }
  
  private_subnet_tags = {
    "kubernetes.io/cluster/migration-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"            = "1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"
  
  cluster_name    = "migration-eks-cluster"
  cluster_version = "1.33"
  
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  
  # Cluster access configuration
  cluster_endpoint_private_access = false
  # cluster_endpoint_public_access  = true
  
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  
  eks_managed_node_groups = {
    dev = {
      name           = "migration-nodes"
      instance_types = ["t3.medium"]
      
      min_size     = 1
      max_size     = 3
      desired_size = 2
      
      # Use the latest EKS optimized AMI
      ami_type = "AL2_x86_64"
      
      # Disk configuration
      disk_size = 20
      
      # Update configuration
      update_config = {
        max_unavailable_percentage = 25
      }
      
      # Labels
      labels = {
        Environment = "dev"
        NodeGroup   = "dev"
      }
      
      # Taints
      taints = {}
      
      tags = {
        ExtraTag = "migration-nodes"
      }
    }
  }
  
  # aws-auth configmap - disable automatic management to avoid connectivity issues
  manage_aws_auth_configmap = false
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# Data source for current AWS account ID
data "aws_caller_identity" "current" {}
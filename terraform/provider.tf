provider "aws" {
  region = var.region
}

terraform {
  required_version = ">=1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.27.0"
    }
  }
}
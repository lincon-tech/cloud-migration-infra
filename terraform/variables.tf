variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "cluster_name" {
  default = "migration-eks-cluster"
}

variable "subnet_ids" {}

variable "vpc_id" {}
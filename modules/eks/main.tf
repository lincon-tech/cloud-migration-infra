resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.cluster_role
  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}
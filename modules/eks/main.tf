resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  node_group_name = "migration-workers"
  role_arn = var.cluster_role

  instance_types = var.node_instance_type

  scaling_config {

    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size

  }

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}
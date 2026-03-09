variable "cluster_name" {}

variable "subnet_ids" {}


variable "vpc_id" {}

variable "cluster_role" {
  default = "arn:aws:iam::953831643964:role/eksClusterRole"
}
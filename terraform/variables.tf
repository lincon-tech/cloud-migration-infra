variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "production-eks"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "desired_size" {
  default = 2
}

variable "max_size" {
  default = 4
}

variable "min_size" {
  default = 2
}
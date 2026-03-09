variable "cluster_name" {}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS"
  type        = list(string)
}
 
 
variable "vpc_id" {}

variable "node_instance_type" {
  description = "Instance type for worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "cluster_role" {
  default = "arn:aws:iam::953831643964:role/eksClusterRole"
}
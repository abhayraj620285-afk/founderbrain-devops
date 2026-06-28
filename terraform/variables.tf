variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "founderbrain-cluster"
}

variable "aws_instance_type" {
  default = "t3.small"
}

variable "desired_nodes" {
  default = 2
}

variable "min_nodes" {
  default = 1
}

variable "max_nodes" {
  default = 2
}

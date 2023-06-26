locals {
  subnet_common_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}
variable "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "region_name" {
  description = "Region name to launch VPC network"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC network CIDR"
  type        = string
}

variable "environment" {
  description = "Environment name for deployment"
  type        = string
}

variable "public_subnets" {
  description = "Provider public subnets CIDR values"
  type        = map(any)
}

variable "private_subnets" {
  description = "Provide private subnets CIDR values"
  type        = map(any)
}

variable "pub_sub_tags" {
  description = "Provide tags that needs to be as part of EKS network to manage ELB internet-facing"
  type        = map(any)
  default = {
    "kubernetes.io/role/elb" = "1"
  }
}

variable "priv_sub_tags" {
  description = "Provide tags that needs to be as part of EKS network to manage ELB internal-elb"
  type        = map(any)
  default = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

provider "aws" {
  region = var.region_name
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

#module to launch vpc with two  private and two public subnets
module "webapp_vpc" {
  source = "./vpc"

  environment     = var.environment
  region_name     = var.region_name
  eks_cluster_name = var.eks_cluster_name

  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

##Module to launch EKS cluster 
module "webapp_cluster" {
  source = "./webapp_cluster"

  eks_subnet_ids   = flatten([module.webapp_vpc.priv_subnets])
  eks_cluster_name = var.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version
  cluster_role     = var.cluster_role

  depends_on = [
    module.webapp_vpc
  ]
}
##Module for eks node group 
module "eks_node_group" {
  source = "./node_group"

  eks_subnet_ids    = flatten([module.webapp_vpc.priv_subnets])
  eks_cluster_name  = module.webapp_cluster.cluster_name
  eks_cluster_version  = var.eks_cluster_version
  node_group_name   = var.node_group_name
  node_role_name    = var.node_role_name
  nodegroup_keypair = var.nodegroup_keypair

  depends_on = [
    module.webapp_cluster,
    module.webapp_vpc
  ]
}
#module for ecr repo 

module "ecr" {
  source = "./ecr"
}

#module to setup K8s componenss

module "k8s" {
  source = "./k8s-manifests"

depends_on = [
    module.webapp_cluster,
    module.webapp_vpc,
    module.eks_node_group,
    module.ecr

]
}


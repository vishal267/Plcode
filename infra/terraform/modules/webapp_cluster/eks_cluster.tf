resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  version  =  var.eks_cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.eks_subnet_ids
## can comment below option to disable public acces
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role.eks_cluster_role
  ]
}

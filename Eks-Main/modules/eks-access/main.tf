resource "aws_eks_access_entry" "example" {
  cluster_name      = var.eks_cluster_name
  principal_arn     = var.principal_arn
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "main" {
  count         = var.cluster_level ? 1 : 0
  cluster_name  = var.eks_cluster_name
  policy_arn    = var.policy_arn
  principal_arn = var.principal_arn

  access_scope {
    type       = "cluster"
  }
}

resource "aws_eks_access_policy_association" "main" {
  count         = var.cluster_level ? 0 : 1
  cluster_name  = var.eks_cluster_name
  policy_arn    = var.policy_arn
  principal_arn = var.principal_arn

  access_scope {
    type       = "namespace"
    namespaces = var.namespaces
  }
}



variable "eks_cluster_name" {}
variable "principal_arn" {}
variable "policy_arn" {}
variable "cluster_level" {}
variable "namespaces" {
  default = null
}

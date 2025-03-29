resource "aws_eks_access_entry" "example" {
  for_each          = var.eks_access_config
  cluster_name      = var.eks_cluster_name
  principal_arn     = each.value["principal_arn"]
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "main" {
  for_each      = aws_eks_access_entry.example

  cluster_name  = var.eks_cluster_name
  policy_arn    = lookup(lookup(var.eks_access_config,each.key,null),"policy_arn",null)
  principal_arn = each.value.principal_arn

  access_scope {
    type       = "cluster"
  }

}


variable "eks_cluster_name" {}
variable "eks_access_config" {}
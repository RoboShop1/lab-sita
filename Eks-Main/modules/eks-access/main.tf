resource "aws_eks_access_entry" "example" {
  for_each          = var.aws_eks_access_entry
  cluster_name      = var.eks_cluster_name
  principal_arn     = each.value["principal_arn"]
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "main" {
  for_each      = aws_eks_access_entry.example

  cluster_name  = var.eks_cluster_name
  policy_arn    = lookup(lookup(var.aws_eks_access_entry,each.key,null),"policy_arn",null)
  principal_arn = each.value.principal_arn

  access_scope {
    type       = "cluster"
  }

}


variable "eks_cluster_name" {}
variable "aws_eks_access_entry" {}
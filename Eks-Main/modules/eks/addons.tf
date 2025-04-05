resource "aws_eks_addon" "addons" {
  depends_on                  = [aws_eks_node_group.main]
  for_each                    =  var.addons
  cluster_name                = aws_eks_cluster.example.name
  addon_name                  = each.key
  addon_version               = each.value["addon_version"]
  resolve_conflicts_on_update = "OVERWRITE"
}


resource "aws_iam_role" "pod-associations-roles" {
  for_each           =  var.aws_eks_pod_identity_associations
  name               = each.key
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ],
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })
  inline_policy {
    name   = each.key["policy_name"]
    policy = jsonencode(each.value["policy"])
  }
}





resource "aws_eks_pod_identity_association" "aws_eks_pod_asa" {
  for_each        = aws_iam_role.pod-associations-roles
  cluster_name    = aws_eks_cluster.example.name
  namespace       = lookup(lookup(var.aws_eks_pod_identity_associations,each.key,null),"namespace",null)
  service_account = lookup(lookup(var.aws_eks_pod_identity_associations,each.key,null),"service_account ",null)
  role_arn        = each.value.arn
}
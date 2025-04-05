resource "aws_eks_node_group" "main" {
  for_each        = var.node_groups
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "${each.key}"
  node_role_arn   = aws_iam_role.node_main.arn
  subnet_ids      = each.value["subnets"]
  capacity_type   = "SPOT"
  instance_types  = each.value["instance_types"]

  scaling_config {
    desired_size = each.value["desired_size"]
    max_size     = each.value["max_size"]
    min_size     = each.value["min_size"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_role_attachments
  ]

  tags = {
    Name = "${var.env}-eks-${each.key}"
  }
}






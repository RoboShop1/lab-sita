resource "aws_eks_node_group" "node_group_1a" {
  cluster_name         = aws_eks_cluster.example.name
  node_group_name      = "${var.env}-eks-node-group-1a"
  node_role_arn        = aws_iam_role.node_main.arn
  subnet_ids           = var.node_group_1a["subnets"]
  capacity_type        = "SPOT"
  instance_types       = var.node_group_1a["instance_types"]
  force_update_version = true

  scaling_config {
    desired_size = var.node_group_1a["desired_size"]
    max_size     = var.node_group_1a["max_size"]
    min_size     = var.node_group_1a["min_size"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_role_attachments
  ]

  tags = {
    Name = "${var.env}-eks-node-group-1a"
  }
}


resource "aws_eks_node_group" "node_group_1b" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "${var.env}-eks-node-group-1b"
  node_role_arn   = aws_iam_role.node_main.arn
  subnet_ids      = var.node_group_1b["subnets"]
  capacity_type   = "SPOT"
  instance_types  = var.node_group_1b["instance_types"]
  force_update_version = true

  scaling_config {
    desired_size = var.node_group_1b["desired_size"]
    max_size     = var.node_group_1b["max_size"]
    min_size     = var.node_group_1b["min_size"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_role_attachments
  ]

  tags = {
    Name = "${var.env}-eks-node-group-1b"
  }
}




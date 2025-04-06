resource "aws_eks_node_group" "node_group_blue_1a" {
  count           = var.cluster_upgrade ? 1 : 0
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "${var.env}-eks-node-group-blue-1a"
  node_role_arn   = aws_iam_role.node_main.arn
  subnet_ids      = var.node_group_1a["subnets"]
  capacity_type   = "SPOT"
  instance_types  = var.node_group_1a["instance_types"]

  scaling_config {
    desired_size = var.node_group_1a["desired_size"]
    max_size     = var.node_group_1a["max_size"]
    min_size     = var.node_group_1a["min_size"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_role_attachments
  ]

  tags = {
    Name = "${var.env}-eks-node-group-blue-1a"
  }
}


resource "aws_eks_node_group" "node_group_blue_1b" {
  count           = var.cluster_upgrade ? 1 : 0
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "${var.env}-eks-node-group-blue-1b"
  node_role_arn   = aws_iam_role.node_main.arn
  subnet_ids      = var.node_group_1b["subnets"]
  capacity_type   = "SPOT"
  instance_types  = var.node_group_1b["instance_types"]

  scaling_config {
    desired_size = var.node_group_1b["desired_size"]
    max_size     = var.node_group_1b["max_size"]
    min_size     = var.node_group_1b["min_size"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_role_attachments
  ]

  tags = {
    Name = "${var.env}-eks-node-group-blue-1b"
  }
}

# locals {
#   old_worker_node_version = var.k8_version == "1.22" ? "v1.21.14-eks-fb459a0" : "v1.22.15-eks-fb459a0"
# }


# resource "null_resource" "cordon_n_drain_node" {
#   depends_on = [
#     aws_eks_node_group.eks-node-group-ap_south_blue_1a[0],
#     aws_eks_node_group.eks-node-group-ap_south_blue_1b[0],
#     aws_eks_node_group.eks-node-group-ap_south_blue_1c[0],
#     aws_eks_node_group.eks-node-group-ap_south_1a,
#     aws_eks_node_group.eks-node-group-ap_south_1b,
#     aws_eks_node_group.eks-node-group-ap_south_1c
#   ]
#   count = var.upgarde_cluster ? 1 : 0
#   provisioner "local-exec" {
#     command = "/bin/sh ${path.module}/workernode_upgrade_prereq.sh ${var.env} ${var.cluster_name} ${local.old_worker_node_version}"
#   }
# }

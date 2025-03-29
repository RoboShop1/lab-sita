output "eks_sg_id" {
  value = aws_eks_cluster.example.vpc_config.cluster_security_group_id
}
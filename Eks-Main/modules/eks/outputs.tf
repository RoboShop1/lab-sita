output "eks_sg_id" {
  value = aws_eks_cluster.example.vpc_config[0].cluster_security_group_id
}
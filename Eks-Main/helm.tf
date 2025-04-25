
resource "null_resource" "kubectl-config" {
  depends_on = [module.eks]
  provisioner "local-exec" {
    command =<<EOT
aws eks update-kubeconfig --name dev-eks
EOT
  }
}


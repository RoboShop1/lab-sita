aws_eks_access_entry ={
  terraform_role = {
    principal_arn = "arn:aws:iam::339712959230:role/terraform_role"
    policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  }
}
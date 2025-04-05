aws_eks_access_entry ={
  terraform_role = {
    principal_arn = "arn:aws:iam::339712959230:role/terraform_role"
    policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    cluster_level = true
    namespaces    = []
  }
  connect = {
    principal_arn = "arn:aws:iam::339712959230:user/connect"
    policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
    cluster_level = false
    namespaces    = ["dev","qa"]
  }
}
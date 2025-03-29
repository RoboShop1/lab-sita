eks = {
  main = {
    eks_version = ""

    node_groups = {
      node_group1 = {
        subnets        = ""
        desired_size   = 2
        max_size       = 2
        min_size       = 1
        instance_types = ["t3.small"]
      }
    }

    node_polices   = [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
    ]

  }
}
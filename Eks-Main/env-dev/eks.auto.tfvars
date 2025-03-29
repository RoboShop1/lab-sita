eks = {
  main = {
    eks_version = "1.30"

    node_groups = {
      node_group1 = {
        subnets        = ["subnet-0972408cb0b198678","subnet-02890fd1149b78261"]
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
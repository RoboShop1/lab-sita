module "eks" {
  for_each        = var.eks
  source          = "./modules/eks"
  env             = each.key
  eks_subnets     = each.value["eks_subnets"]
  eks_version     = each.value["eks_version"]
  node_polices    = each.value["node_polices"]
  node_group_1a   = each.value["node_group_1a"]
  node_group_1b   = each.value["node_group_1b"]
  cluster_upgrade =  var.cluster_upgrade
}


variable "cluster_upgrade" {
  default = false
}

variable "eks" {
  default = {
    dev  = {
      eks_version      = "1.30"
      eks_subnets      = ["subnet-0843f25967fb0b18d","subnet-0354194ae815795f6"]
      node_polices     = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      ]
      node_group_1a    = {subnets = ["subnet-0843f25967fb0b18d","subnet-0354194ae815795f6"], instance_types= ["t3.small"], desired_size = "2" ,max_size= "3", min_size = "1"}
      node_group_1b    = {subnets = ["subnet-0843f25967fb0b18d","subnet-0354194ae815795f6"], instance_types= ["t3.small"], desired_size = "2" ,max_size= "3", min_size = "1"}
    }
  }
}
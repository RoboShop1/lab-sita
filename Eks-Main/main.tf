
module "vpc" {
  source          = "./modules/vpc"
  for_each        = var.vpc
  env             = var.env
  vpc_cidr_block  = each.value["vpc_cidr_block"]
  public_subnets  = each.value["public_subnets"]
  app_subnets     = each.value["app_subnets"]
  db_subnets      = each.value["db_subnets"]
}


output "app_subnets" {
  value = element(values({for i,j in lookup(module.vpc["main"],"app_subnets",null): i => j.id}),0)
}



module "eks" {
  for_each                          = var.eks
  source                            = "./modules/eks"
  env                               = var.env
  eks_subnets                       = values({for i,j in lookup(module.vpc["main"],"app_subnets",null): i => j.id})
  eks_version                       = each.value["eks_version"]
  node_groups                       = each.value["node_groups"]
  node_polices                      = each.value["node_polices"]
  addons                            = each.value["addons"]
  aws_eks_pod_identity_associations = each.value["aws_eks_pod_identity_associations"]
}

#
# module "eks_access" {
#   for_each              = var.aws_eks_access_entry
#   depends_on            = [module.eks]
#   source                = "./modules/eks-access"
#   eks_cluster_name      = "dev-eks"
#   principal_arn         = each.key["principal_arn"]
#   policy_arn            = each.key["policy_arn"]
#   cluster_level         = each.key["cluster_level"]
#   namespaces            = each.key["namespaces"]
# }




# output "eks_sg_id" {
#   value = module.eks
# }
#
resource "aws_instance" "main" {
#  count         = element(values({for i,j in lookup(module.vpc["main"],"app_subnets",null): i => j.id}),0)
  ami           = "ami-0b4f379183e5706b9"
  instance_type = "t2.micro"
  subnet_id     = element(values({for i,j in lookup(module.vpc["main"],"public_subnets",null): i => j.id}),0)
  iam_instance_profile = aws_iam_instance_profile.test_profile.name

  tags = {
    Name = "Instance-sample"
  }
}


output "public" {
  value = aws_instance.main.public_ip
}

resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = lookup(module.vpc["main"],"default_security_group_id",null)

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "eks-sg" {
  security_group_id = lookup(module.eks["main"],"eks_sg_id",null)

  cidr_ipv4   = "10.0.0.0/16"
  ip_protocol = "-1"
}
















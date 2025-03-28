
module "vpc" {
  source          = "./modules/vpc"
  for_each        = var.vpc
  env             = var.env
  vpc_cidr_block  = each.value["vpc_cidr_block"]
  public_subnets  = each.value["public_subnets"]
  app_subnets     = each.value["app_subnets"]
  db_subnets      = each.value["db_subnets"]
}

# module "eks" {
#   for_each                     = var.eks
#   source                       = "./modules/eks"
#   env                          = var.env
#   eks_subnets                  = ""
#   eks_version                  = each.value["eks_version"]
#   node_groups                  = each.value["node_groups"]
#  # node_role_policy_attachments = each.value["node_role_policy_attachments"]
# }











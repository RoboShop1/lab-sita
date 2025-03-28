module "vpc" {
  source          = "./modules/vpc"
  for_each        = var.vpc
  env             = var.env
  vpc_cidr_block  = each.value["vpc_cidr_block"]
  public_subnets  = each.value["public_subnets"]
  app_subnets     = each.value["app_subnets"]
  db_subnets      = each.value["db_subnets"]
}

output "main" {
  value =  {for i,j in module.vpc["main"]: i => {for m,n in j: m => n.id } }
}





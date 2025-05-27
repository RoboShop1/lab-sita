
module "ec2" {
  for_each      = var.ec2
  source        = "./modules/ec2"
  ami_id        = each.value["ami_id"]
  instance_type = each.value["instance_type"]
  env           = var.env
  name          = each.key
}



# module "s3" {
#
#   source   = "./modules/s3"
#   for_each = var.s3
#   env      = each.value["env"]
# }
#
# module "endpoint" {
#   source   = "./modules/endpoint"
#   for_each = var.endpoint
#   env      = each.value["env"]
# }
#
# module "rds" {
#   source   = "./modules/rds"
#   for_each = var.rds
#   env      = each.value["env"]
# }
#
# module "eks" {
#   source   = "./modules/eks"
#   for_each = var.eks
#   env      = each.value["env"]
# }

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
  for_each                     = var.eks
  source                       = "./modules/eks"
  env                          = var.env
  eks_subnets                  = values({for i,j in lookup(module.vpc["main"],"app_subnets",null): i => j.id})
  eks_version                  = each.value["eks_version"]
  node_groups                  = each.value["node_groups"]
  node_polices                 = each.value["node_polices"]
}



resource "aws_instance" "main" {
#  count         = element(values({for i,j in lookup(module.vpc["main"],"app_subnets",null): i => j.id}),0)
  ami           = "ami-0b4f379183e5706b9"
  instance_type = "t2.micro"
  subnet_id     = element(values({for i,j in lookup(module.vpc["main"],"app_subnets",null): i => j.id}),0)
  iam_instance_profile = aws_iam_instance_profile.test_profile.name

  tags = {
    Name = "Instance-sample"
  }
}


# resource "aws_instance" "main1" {
#   #  count         = element(values({for i,j in lookup(module.vpc["main"],"app_subnets",null): i => j.id}),0)
#   ami           = "ami-0b4f379183e5706b9"
#   instance_type = "t2.micro"
#   subnet_id     = element(values({for i,j in lookup(module.vpc["main"],"public_subnets",null): i => j.id}),0)
#   iam_instance_profile = aws_iam_instance_profile.test_profile.name
#
#   tags = {
#     Name = "Instance-sample"
#   }
# }


resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = lookup(module.vpc["main"],"default_security_group_id",null)

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}


#
# resource "aws_instance" "db" {
#   for_each       =  lookup({for i,j in module.vpc["main"]: i => {for m,n in j: m => n.id } },"db_subnets", null)
#   ami            =  "ami-0b4f379183e5706b9"
#   instance_type  = "t2.micro"
#   subnet_id      = each.value
#
#   tags = {
#     Name = "Instance-${each.key}"
#   }
# }


# output "main" {
#   value = module.vpc
# }

# output "p" {
#   value = { for i,j in module.vpc["main"]: i => { for m,n in j: m => n["id"] }}
# }
#
# output "n" {
#   value = {for i,j in module.vpc["main"]: i => {for m,n in j: m => n.id } }
# }
# resource "aws_vpc_security_group_ingress_rule" "example" {
#   security_group_id = module.vpc.sg_id
#
#   cidr_ipv4   = "0.0.0.0"
#   from_port   = 22
#   ip_protocol = "tcp"
#   to_port     = 22
# }

# module "eks" {
#   for_each                     = var.eks
#   source                       = "./modules/eks"
#   env                          = var.env
#   eks_subnets                  = ""
#   eks_version                  = each.value["eks_version"]
#   node_groups                  = each.value["node_groups"]
#  # node_role_policy_attachments = each.value["node_role_policy_attachments"]
# }











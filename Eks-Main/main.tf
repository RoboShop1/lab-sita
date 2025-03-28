
module "vpc" {
  source          = "./modules/vpc"
  for_each        = var.vpc
  env             = var.env
  vpc_cidr_block  = each.value["vpc_cidr_block"]
  public_subnets  = each.value["public_subnets"]
  app_subnets     = each.value["app_subnets"]
  db_subnets      = each.value["db_subnets"]
}



resource "aws_instance" "main" {
  for_each       =  lookup({for i,j in module.vpc["main"]: i => {for m,n in j: m => n.id } },"public_subnets", null)
  ami            =  "ami-0b4f379183e5706b9"
  instance_type  = "t2.micro"
  subnet_id      = each.value


  tags = {
    Name = "Instance-${each.key}"
  }
}

resource "aws_instance" "app" {
  for_each       =  lookup({for i,j in module.vpc["main"]: i => {for m,n in j: m => n.id } },"app_subnets", null)
  ami            =  "ami-0b4f379183e5706b9"
  instance_type  = "t2.micro"
  subnet_id      = each.value

  tags = {
    Name = "Instance-${each.key}"
  }
}

resource "aws_instance" "db" {
  for_each       =  lookup({for i,j in module.vpc["main"]: i => {for m,n in j: m => n.id } },"db_subnets", null)
  ami            =  "ami-0b4f379183e5706b9"
  instance_type  = "t2.micro"
  subnet_id      = each.value

  tags = {
    Name = "Instance-${each.key}"
  }
}


output "main" {
  value = module.vpc
}
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











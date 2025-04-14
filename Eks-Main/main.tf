terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}
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

module "eks_access" {
  for_each              = var.aws_eks_access_entry
  depends_on            = [module.eks]
  source                = "./modules/eks-access"
  eks_cluster_name      = "dev-eks"
  principal_arn         = each.value["principal_arn"]
  policy_arn            = each.value["policy_arn"]
  cluster_level         = each.value["cluster_level"]
  namespaces            = each.value["namespaces"]
}


# output "eks_sg_id" {
#   value = module.eks
# }

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
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
  referenced_security_group_id = lookup(module.vpc["main"],"default_security_group_id",null)
}


# resource "null_resource" "tools-install" {
#
#   connection {
#     type     = "ssh"
#     user     = "centos"
#     password = "DevOps321"
#     host     = aws_instance.main.public_ip
#   }
#
#   provisioner "remote-exec" {
#     inline = [
#       "sudo labauto kubectl",
#       "sudo labauto helm",
#       "sudo labauto k9s"
#     ]
#
#   }
# }






resource "null_resource" "main" {
  triggers = {
    name = timestamp()
  }
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = aws_instance.main.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "aws eks update-kubeconfig  --name dev-eks --region us-east-1",
      "helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/",
      "helm upgrade --install external-dns external-dns/external-dns --version 1.16.1 --set serviceAccount.name=external-dns-sa"
    ]
  }
  }











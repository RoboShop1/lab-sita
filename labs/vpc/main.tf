# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "5.54.1"
#     }
#   }
# }
#
# # module "vpc" {
# #   for_each       = var.vpc
# #   source         = "./module"
# #   vpc_cidr_block = each.value["vpc_cidr_block"]
# #   env            = each.key
# #   public_subnets = each.value["public_subnets"]
# #   app_subnets    = each.value["app_subnets"]
# #   db_subnets     = each.value["db_subnets"]
# # }
#
#
#
#
# # output "all" {
# #   value = module.vpc
# # }
#
#
#
# output "data" {
#   value = { for i,j in lookup(lookup(module.vpc, "dev",null),"public_subnets",null): i => j["id"]}
# }
# # output "data" {
# #   value = {for i,j in lookup(module.vpc, "dev",null): i => {for m,n in j: m => lookup(n,"id",null)} }
# # }
# #
# #
# # output "public_subnets" {
# #   value = lookup({for i,j in lookup(module.vpc, "dev",null): i => {for m,n in j: m => n["id"]} },"public_subnets",null)
# # }
#
#
# resource "aws_security_group" "public" {
#   name        = "public_sg"
#   description = "for public-subnets"
#   vpc_id      = lookup(lookup(module.vpc, "dev",null),"vpc_id",null)
#
#   ingress {
#     from_port = 22
#     to_port = 22
#     protocol = "TCP"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
#
# resource "aws_security_group" "app" {
#   name = "app_sg"
#   description = "for public-subnets"
#   vpc_id      = lookup(lookup(module.vpc, "dev",null),"vpc_id",null)
#
#   ingress {
#     from_port = 22
#     to_port = 22
#     protocol = "TCP"
#     cidr_blocks = ["10.0.1.0/24","10.0.2.0/24"]
#   }
#
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
#
#
#
#
# resource "aws_instance" "public_subnets" {
#
#   for_each      = { for i,j in lookup(lookup(module.vpc, "dev",null),"public_subnets",null): i => j["id"]}
#   ami           = "ami-0b4f379183e5706b9"
#   instance_type = "t2.micro"
#   subnet_id     = each.value
#
#   vpc_security_group_ids = [aws_security_group.public.id]
#
#   tags = {
#     Name = "${each.key}"
#   }
# }
#
#
# resource "aws_instance" "app_subnets" {
#
#   for_each      = { for i,j in lookup(lookup(module.vpc, "dev",null),"app_subnets",null): i => j["id"]}
#   ami           = "ami-0b4f379183e5706b9"
#   instance_type = "t2.micro"
#   subnet_id     = each.value
#
#   vpc_security_group_ids = [aws_security_group.app.id]
#
#   tags = {
#     Name = "${each.key}"
#   }
# }
#
#
#
# output "app_instances" {
#   value = {for i,j in aws_instance.app_subnets: i => j.private_ip}
# }
#
#
# output "public_instances" {
#   value = { for i,j in aws_instance.public_subnets: i => j.public_ip }
# }
#
#
#
# variable "vpc" {
#   default = {
#     dev = {
#       vpc_cidr_block = "10.0.0.0/16"
#       public_subnets = {
#         public1 = { cidr_block = "10.0.1.0/24" , az = "us-east-1a" }
#         public2 = { cidr_block = "10.0.2.0/24" , az = "us-east-1b" }
#       }
#       app_subnets = {
#         app1 = { cidr_block = "10.0.3.0/24" , az = "us-east-1a" }
#         app2 = { cidr_block = "10.0.4.0/24" , az = "us-east-1b" }
#       }
#       db_subnets = {
#         db1 = { cidr_block = "10.0.5.0/24" , az = "us-east-1a" }
#         db2 = { cidr_block = "10.0.6.0/24" , az = "us-east-1b" }
#       }
#     }
#   }
# }








#
#
# variable "sg" {
#   default = {
#     ssh = {
#       from_port = 22
#       to_port   = 22
#       protocol = "TCP"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#     http = {
#       from_port = 80
#       to_port   = 80
#       protocol = "TCP"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }
#
#
# resource "aws_security_group" "app" {
#   name = "app_sg"
#   description = "for public-subnets"
#
#   dynamic "ingress" {
#     for_each = var.sg
#     content {
#       from_port = ingress.value["from_port"]
#       to_port = ingress.value["to_port"]
#       protocol = ingress.value["protocol"]
#       cidr_blocks = ingress.value["cidr_blocks"]
#     }
#   }
#
#
#
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
#
#
# variable "sg1" {
#   default = [22,80]
# }
#
# resource "aws_security_group" "app1" {
#   name = "app_sg1"
#   description = "for public-subnets"
#
#   dynamic "ingress" {
#     for_each = var.sg1
#     content {
#       from_port = ingress.value
#       to_port = ingress.value
#       protocol = "TCP"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
#
#
#
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
#
variable "sg2" {
  default = {
    ssh = 22
    web = 80
    rds = 3306
  }
}

resource "aws_security_group" "app2" {
  name = "app_sg2"
  description = "for public-subnets"

  dynamic "ingress" {
    for_each = var.sg2
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }



  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}







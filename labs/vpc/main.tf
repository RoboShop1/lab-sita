terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}
module "vpc" {
  for_each       = var.vpc
  source         = "./module"
  vpc_cidr_block = each.value["vpc_cidr_block"]
  env            = each.key
  public_subnets = each.value["public_subnets"]
  app_subnets    = each.value["app_subnets"]
  db_subnets     = each.value["db_subnets"]
}




output "all" {
  value = module.vpc
}


output "data" {
  value = {for i,j in lookup(module.vpc, "dev",null): i => {for m,n in j: m => n["id"]} }
}


output "public_subnets" {
  value = lookup({for i,j in lookup(module.vpc, "dev",null): i => {for m,n in j: m => n["id"]} },"public_subnets",null)
}




resource "aws_instance" "public_subnets" {
  for_each =
  ami = ""
  instance_type = ""

  tags = {
    Name = "${each.key}"
  }
}


variable "vpc" {
  default = {
    dev = {
      vpc_cidr_block = "10.0.0.0/16"
      public_subnets = {
        public1 = { cidr_block = "10.0.1.0/24" , az = "us-east-1a" }
        public2 = { cidr_block = "10.0.2.0/24" , az = "us-east-1b" }
      }
      app_subnets = {
        app1 = { cidr_block = "10.0.3.0/24" , az = "us-east-1a" }
        app2 = { cidr_block = "10.0.4.0/24" , az = "us-east-1b" }
      }
      db_subnets = {
        db1 = { cidr_block = "10.0.5.0/24" , az = "us-east-1a" }
        db2 = { cidr_block = "10.0.6.0/24" , az = "us-east-1b" }
      }
    }
  }
}
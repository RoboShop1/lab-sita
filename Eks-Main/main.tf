
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



resource "aws_instance" "main" {
  for_each       =  lookup({for i,j in module.vpc["main"]: i => {for m,n in j: m => n.id } },"public_subnets", null)
  ami            =  "ami-071226ecf16aa7d96"
  instance_type  = "t2.micro"
  subnet_id      = each.value

  tags = {
    Name = "Instance-${each.key}"
  }
}

resource "aws_instance" "app" {
  for_each       =  lookup({for i,j in module.vpc["main"]: i => {for m,n in j: m => n.id } },"app_subnets", null)
  ami            =  "ami-071226ecf16aa7d96"
  instance_type  = "t2.micro"
  subnet_id      = each.value

  tags = {
    Name = "Instance-${each.key}"
  }
}

resource "aws_instance" "db" {
  for_each       =  lookup({for i,j in module.vpc["main"]: i => {for m,n in j: m => n.id } },"db_subnets", null)
  ami            =  "ami-071226ecf16aa7d96"
  instance_type  = "t2.micro"
  subnet_id      = each.value

  tags = {
    Name = "Instance-${each.key}"
  }
}






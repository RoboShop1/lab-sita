vpc = {
  main = {
    vpc_cidr_block = "10.0.0.0/16"
    public_subnets = {
      public1 = {cidr_block = "10.0.1.0/24", az = "us-east-1a"}
      public2 = {cidr_block = "10.0.2.0/24", az = "us-east-1b"}
    }
    app_subnets = {
      app1 = {cidr_block = "10.0.3.0/24", az = "us-east-1a"}
      app2 = {cidr_block = "10.0.4.0/24", az = "us-east-1b"}
    }
    db_subnets = {
      db1 = {cidr_block = "10.0.5.0/24", az = "us-east-1a"}
      db2 = {cidr_block = "10.0.6.0/24", az = "us-east-1b"}
    }
  }
}
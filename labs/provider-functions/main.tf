provider "aws" {
  region = "us-east-1"
}

locals {
  az = aws.count_availability_zones(region = "us-west-2")
}


locals {
  region_code = aws.region_code("US West (Oregon)")
}

locals {
  monthly_cost = cloudprovider.estimate_cost({
instance_type = "t3.large",
hours         = 730
})
}
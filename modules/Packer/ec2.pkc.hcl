
packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}



source "amazon-ebs" "basic-example" {
  ami_name = "chaitu-custom"
  force_deregister = true
  force_delete_snapshot = true

  instance_type = "t3.small"

  source_ami    = "i-0dc6ce6f7933ab154"
  tags = {
    Name = "chaitu-custom"
  }

  run_tags = {
    Name = "RunAMI"
  }
  launch_block_device_mappings {
    device_name = "/dev/sdf"
    volume_size = 10
  }
  communicator = "ssh"
  ssh_username = "centos"
  ssh_password = "DevOps321"
}


build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.basic-example"
  ]
}
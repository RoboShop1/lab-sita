
packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}



source "amazon-ebs" "basic-example" {
  ami_name = "chaitu-custom-{{timestamp}}"
  force_deregister = true
  force_delete_snapshot = true

  instance_type = "t3.small"

  source_ami    = "ami-0b4f379183e5706b9"

  tags = {
    Name = "chaitu-custom"
  }

  run_tags = {
    Name = "RunAMI"
  }

  launch_block_device_mappings {
    device_name = "/dev/sdf"
    volume_size = 10
    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name = "/dev/sdg"
    volume_size = 10
    delete_on_termination = true
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

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Installing nginx",
      "sudo dnf install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "sudo dnf install git -y",
      "sudo dnf install wget -y"
    ]
  }

}
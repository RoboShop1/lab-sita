resource "aws_launch_template" "foo" {
  name = "sample"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
    }
  }

  block_device_mappings {
    device_name = "/dev/sdb"

    ebs {
      volume_size =  10
    }
  }

  image_id = "ami-0b4f379183e5706b9"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-0665a56c7cd09a0e0"]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Dev_Instance"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "Dev_volume"
    }
  }
  user_data = filebase64("${path.module}/example.sh")
}



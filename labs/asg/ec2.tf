
resource "aws_instance" "main" {
  launch_template {
    version = "3"
    id      = "lt-059250556e7f305e4"
  }
}



resource "aws_instance" "main1" {
  launch_template {
    version = "2"
    id      = "lt-059250556e7f305e4"
  }
}
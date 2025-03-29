data "aws_iam_role" "example" {
  name = "terraform_role"
}


resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = data.aws_iam_role.example.name
}



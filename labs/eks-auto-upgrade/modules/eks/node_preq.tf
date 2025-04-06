resource "aws_iam_role" "node_main" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "node_role_attachments" {
  for_each   = toset(var.node_polices)
  role       = aws_iam_role.node_main.name
  policy_arn = each.value
}
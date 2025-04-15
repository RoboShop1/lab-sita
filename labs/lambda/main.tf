data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


data "archive_file" "lambda" {
  type        = "zip"
  source_dir = "./python"
  output_path = "sample.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "${path.module}/python/name.zip"
  function_name = "sample"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "sample.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = "python3.11"
  timeout = "60"

}

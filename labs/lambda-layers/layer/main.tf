resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = "two"
  description         = "My Python layer with requests"
  s3_bucket           = "goodchaitu"
  s3_key              = "sample.zip"
  compatible_runtimes = ["python3.11"]
  compatible_architectures = ["x86_64"]
  source_code_hash         = filebase64sha256("s3_key")
}
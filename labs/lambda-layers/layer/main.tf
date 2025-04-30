data "aws_s3_object" "bootstrap_script" {
  bucket = "goodchaitu"
  key    = "sample.zip"
}

output "checksum" {
  value = data.aws_s3_object.bootstrap_script.checksum_sha256
}







resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = "two"
  description         = "My Python layer with requests"
  s3_bucket           = "goodchaitu"
  s3_key              = "sample.zip"
  compatible_runtimes = ["python3.11"]
  compatible_architectures = ["x86_64"]
  s3_object_version        = "sample.zip"
}



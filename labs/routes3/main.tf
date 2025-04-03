resource "aws_route53_record" "record-internal" {
  name    = "sample-internal.poornachandra3.online"
  type    = "A"
  zone_id = "Z06926562JRB6HEXD0QMM"
  records = ["10.0.0.0"]
  ttl     = 30
}
resource "aws_route53_record" "cf_distribution" {
  count = "${length(var.domain_from)}"
  zone_id = "${var.route53_zone_id}"
  name    = "${element(var.domain_from,count.index)}"
  type    = "A"

  alias {
    name                   = "${element(aws_cloudfront_distribution.s3_distribution.*.domain_name, count.index)}"
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}
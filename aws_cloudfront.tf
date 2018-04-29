resource "aws_cloudfront_distribution" "s3_distribution" {
  count = "${length(var.domain_from)}"

  origin {
    domain_name = "${element(aws_s3_bucket.s3_redirects.*.website_endpoint,count.index)}"
    origin_id   = "myS3Origin"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${element(var.domain_from,count.index)}"
  default_root_object = ""

  aliases = ["${element(var.domain_from,count.index)}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = "${var.cache_ttl}"
    default_ttl            = "${var.cache_ttl}"
    max_ttl                = "${var.cache_ttl}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn = "${var.certificate_arn}"
    ssl_support_method = "sni-only"
  }
}
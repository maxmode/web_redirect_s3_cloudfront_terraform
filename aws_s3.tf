resource "aws_s3_bucket" "s3_redirects" {
  count = "${length(var.domain_from)}"
  bucket = "redirect-for-${replace(element(var.domain_from,count.index),".","-")}-tf"
  acl    = "private"

  website {
    redirect_all_requests_to = "${var.destination_url}"
  }

  tags {
    Name = "Redirects from ${element(var.domain_from,count.index)}"
  }
}


## Introduction
Terraform module for redirects between domains:
 - Redirect with 301 status code via AWS S3
 - Cover S3 bucket with AWS Cloudfront for https support, caching, IPv6 support, Ddos protection
 - Create AWS Route53 records

## Usage

### Preconditions
1. Create a hosted zone in AWS Route 53 for your domain. The hosted zone should be in use for the domain.
1. Generate Access key and Access token for your AWS User
1. Install `terraform`

### Include it as a module from github

Create file index.tf with your configuration:
```

provider "aws" {
  version = "~> 1.12"
  // Region "us-east-1" will establish Cloudfront <==> S3 integration faster
  region = "us-east-1"
  access_key = "XXXXXX"
  secret_key = "XXXXXXXXXXX"
}

module "web_redirect_s3_cloudfront_terraform" {
  source       = "github.com/maxmode/web_redirect_s3_cloudfront_terraform"

  // Website configuration.
  // Changes in these parameters will take 5..30min due to required update of Cloudfront distribution.
  domain_from = [
    "your_secondary_domain.example.com",
    "your_secondary_domain2.example.com"
  ]
  // SSL certificate, issued by AWS ACM in "us-east-1" region.
  certificate_arn = "arn:aws:acm:us-east-1:956210671995:certificate/fcd166fc-019b-4a2a-86fb-d88ea34dee10"
  cache_ttl = "60" // In seconds. For how long to cache content in Cloudfront.

  // Destination - where to rediract
  destination_url = "https://main_domain.example.com"

  // AWS Route53 Alias record.
  route53_zone_id = "Z1OAF533ZH2KJ" // AWS Route53 Hosted zone ID for your domain
}

```

### Execute terraform
 
 - Run `terraform init`
 - Run `terraform apply`
 - Wait 5..30 min, until Cloudfront synchronizes configuration across all endpoints

### How to check?

Go to website https://your_secondary_domain2.example.com , 
you should be redirected to https://main_domain.example.com

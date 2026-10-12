data "aws_acm_certificate" "issued" {
  domain   = var.certificate_domain_name
  statuses = ["ISSUED"]
}

data "aws_cloudfront_cache_policy" "optimized" {
  name = "Managed-CachingOptimized"
}


data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  name = "Managed-AllViewerExceptHostHeader"
}

#creating Cloudfront distribution -
resource "aws_cloudfront_distribution" "my_distribution" {
  enabled             = true
  aliases             =  [var.additional_domain_name]
  origin {
    domain_name = var.alb_domain_name
    origin_id   = var.alb_domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" #instructs CloudFront to only use HTTP (Port 80) 
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.alb_domain_name
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.optimized.id

    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id

    }
  
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"] 
    }
  }
  tags = {
    Name = var.project_name
  }
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.issued.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}
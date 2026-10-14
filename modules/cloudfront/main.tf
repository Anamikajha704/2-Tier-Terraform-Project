data "aws_cloudfront_cache_policy" "optimized" {
  name = "Managed-CachingOptimized"
}


data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  name = "Managed-AllViewerExceptHostHeader"
}

#creating Cloudfront distribution -
resource "aws_cloudfront_distribution" "my_distribution" {
  enabled             = true
 
  origin {
    domain_name = var.alb_domain_name
    origin_id   = var.alb_domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"  #In a production environment, this would be set to "https-only" to ensure end-to-end encryption.
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.alb_domain_name
    viewer_protocol_policy = "redirect-to-https"  #forces any user trying to access the site via HTTP to securely switch to HTTPS.

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

# If var.acm_certificate_arn is empty, use the free default. 
 # If it is provided, use the custom SSL
 viewer_certificate {
    cloudfront_default_certificate = true

   
     # PRODUCTION REFERENCE (Uncomment if using a custom domain + ACM)-
    # cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
    # acm_certificate_arn            = var.acm_certificate_arn != "" ? var.acm_certificate_arn : null
    # ssl_support_method             = var.acm_certificate_arn != "" ? "sni-only" : null
    # minimum_protocol_version       = "TLSv1.2_2018"
  }
}


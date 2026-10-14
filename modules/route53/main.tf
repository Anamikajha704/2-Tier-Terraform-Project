
data "aws_route53_zone" "public-zone" {
  name         = var.hosted_zone_name
  private_zone = false
}
resource "aws_route53_record" "cloudfront_record" {
  zone_id = data.aws_route53_zone.public-zone.zone_id
  name    = var.additional_domain_name
  type    = "A"

  alias {
    name   = aws_cloudfront_distribution.my_distribution.domain_name
    zone_id = aws_cloudfront_distribution.my_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
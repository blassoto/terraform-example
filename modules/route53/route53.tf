resource "aws_acm_certificate" "cert_app" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

}

data "aws_route53_zone" "zone" {
  name = "${var.domain_name}."
}

resource "aws_route53_record" "cert_app_dns" {
  for_each = {
    for dvo in aws_acm_certificate.cert_app.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

data "aws_lb" "eb_lb" {
  arn = var.load_balancer
}

resource "aws_route53_record" "app_alias" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = data.aws_route53_zone.zone.name
  type    = "A"

  alias {
    name    = data.aws_lb.eb_lb.dns_name
    zone_id = data.aws_lb.eb_lb.zone_id
    evaluate_target_health = true
  }
}

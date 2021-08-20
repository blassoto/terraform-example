output "route53_zone_id" {
  value = data.aws_route53_zone.zone.zone_id
}

output "cert_arn" {
  value = aws_acm_certificate.cert_app.arn
}
resource "aws_ses_domain_identity" "kuiz_mail" {
  domain = var.domain_name
}

resource "aws_route53_record" "kuiz_mail_amazonses_verification_record" {
  zone_id = var.route53_zone_id
  name    = "_amazonses.${var.domain_name}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.kuiz_mail.verification_token]
}
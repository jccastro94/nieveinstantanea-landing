# Zona DNS del dominio. Tras el primer apply, apunte los nameservers del
# registrador actual a la salida `nameservers`.

resource "aws_route53_zone" "principal" {
  name = var.domain
}

# Certificado para apex + www. CloudFront exige us-east-1.
resource "aws_acm_certificate" "sitio" {
  domain_name               = var.domain
  subject_alternative_names = ["www.${var.domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validacion" {
  for_each = {
    for dvo in aws_acm_certificate.sitio.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = aws_route53_zone.principal.zone_id
  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
}

resource "aws_acm_certificate_validation" "sitio" {
  certificate_arn         = aws_acm_certificate.sitio.arn
  validation_record_fqdns = [for r in aws_route53_record.validacion : r.fqdn]
}

# Registros del sitio → CloudFront
resource "aws_route53_record" "apex_a" {
  zone_id = aws_route53_zone.principal.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.sitio.domain_name
    zone_id                = aws_cloudfront_distribution.sitio.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex_aaaa" {
  zone_id = aws_route53_zone.principal.zone_id
  name    = var.domain
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.sitio.domain_name
    zone_id                = aws_cloudfront_distribution.sitio.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_a" {
  zone_id = aws_route53_zone.principal.zone_id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.sitio.domain_name
    zone_id                = aws_cloudfront_distribution.sitio.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_aaaa" {
  zone_id = aws_route53_zone.principal.zone_id
  name    = "www.${var.domain}"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.sitio.domain_name
    zone_id                = aws_cloudfront_distribution.sitio.hosted_zone_id
    evaluate_target_health = false
  }
}

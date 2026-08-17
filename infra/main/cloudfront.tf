resource "aws_cloudfront_origin_access_control" "sitio" {
  name                              = "${var.domain}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Función viewer-request: redirige www → apex y resuelve index.html
resource "aws_cloudfront_function" "reescritura" {
  name    = "nieveinstantanea-reescritura"
  runtime = "cloudfront-js-2.0"
  comment = "www->apex + index.html en rutas de carpeta"
  publish = true
  code    = <<-EOT
    function handler(event) {
      var request = event.request;
      var host = request.headers.host.value;

      if (host === 'www.${var.domain}') {
        return {
          statusCode: 301,
          statusDescription: 'Moved Permanently',
          headers: {
            location: { value: 'https://${var.domain}' + request.uri }
          }
        };
      }

      if (request.uri.endsWith('/')) {
        request.uri += 'index.html';
      } else if (!request.uri.includes('.')) {
        request.uri += '/index.html';
      }
      return request;
    }
  EOT
}

resource "aws_cloudfront_response_headers_policy" "seguridad" {
  name = "nieveinstantanea-seguridad"

  security_headers_config {
    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
  }
}

# Política de caché administrada por AWS: CachingOptimized
data "aws_cloudfront_cache_policy" "optimizada" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "sitio" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Landing ${var.domain}"
  default_root_object = "index.html"
  aliases             = [var.domain, "www.${var.domain}"]
  price_class         = "PriceClass_100" # EE. UU./Europa; el tráfico de CR sale por Miami
  http_version        = "http2and3"

  origin {
    domain_name              = aws_s3_bucket.sitio.bucket_regional_domain_name
    origin_id                = "s3-sitio"
    origin_access_control_id = aws_cloudfront_origin_access_control.sitio.id
  }

  default_cache_behavior {
    target_origin_id           = "s3-sitio"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    cache_policy_id            = data.aws_cloudfront_cache_policy.optimizada.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.seguridad.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.reescritura.arn
    }
  }

  custom_error_response {
    error_code            = 403
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 60
  }

  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 60
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.sitio.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

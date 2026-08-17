output "nameservers" {
  description = "Configure estos NS en el registrador del dominio"
  value       = aws_route53_zone.principal.name_servers
}

output "deploy_role_arn" {
  description = "Variable AWS_DEPLOY_ROLE_ARN en GitHub Actions"
  value       = aws_iam_role.despliegue.arn
}

output "site_bucket" {
  description = "Variable SITE_BUCKET en GitHub Actions"
  value       = aws_s3_bucket.sitio.bucket
}

output "cloudfront_distribution_id" {
  description = "Variable CLOUDFRONT_DISTRIBUTION_ID en GitHub Actions"
  value       = aws_cloudfront_distribution.sitio.id
}

output "cloudfront_domain" {
  description = "Para probar antes de apuntar el dominio"
  value       = aws_cloudfront_distribution.sitio.domain_name
}

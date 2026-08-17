# Despliegue desde GitHub Actions sin llaves de larga vida (OIDC).

resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_github_oidc_provider ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.create_github_oidc_provider ? 0 : 1
  url   = "https://token.actions.githubusercontent.com"
}

locals {
  github_oidc_arn = var.create_github_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn
}

data "aws_iam_policy_document" "confianza_github" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.github_oidc_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Solo la rama main de este repositorio puede desplegar.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "despliegue" {
  name               = "nieveinstantanea-deploy"
  assume_role_policy = data.aws_iam_policy_document.confianza_github.json
}

data "aws_iam_policy_document" "permisos_despliegue" {
  statement {
    sid       = "ListaBucket"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.sitio.arn]
  }

  statement {
    sid       = "EscrituraBucket"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.sitio.arn}/*"]
  }

  statement {
    sid       = "Invalidacion"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [aws_cloudfront_distribution.sitio.arn]
  }
}

resource "aws_iam_role_policy" "despliegue" {
  name   = "despliegue-sitio"
  role   = aws_iam_role.despliegue.id
  policy = data.aws_iam_policy_document.permisos_despliegue.json
}

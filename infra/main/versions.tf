terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }

  backend "s3" {
    bucket       = "nieveinstantanea-terraform-state"
    key          = "main.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

# Todo vive en us-east-1: el certificado de CloudFront lo exige y para un
# sitio estático no hay razón para separar regiones.
#
# default_tags etiqueta TODO recurso que soporte etiquetas. La cuenta de AWS
# se comparte con otro proyecto, así que estas etiquetas son las que permiten
# separar el costo por negocio en Cost Explorer.
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = "nieveinstantanea"
      ManagedBy = "terraform"
      Repo      = var.github_repository
    }
  }
}

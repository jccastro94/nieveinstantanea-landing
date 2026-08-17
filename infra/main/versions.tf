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
provider "aws" {
  region = var.region
}

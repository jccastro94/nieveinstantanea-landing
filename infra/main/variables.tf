variable "region" {
  type    = string
  default = "us-east-1"
}

variable "domain" {
  description = "Dominio raíz del sitio"
  type        = string
  default     = "nieveinstantanea.com"
}

variable "github_repository" {
  description = "Repositorio owner/nombre autorizado a desplegar"
  type        = string
  default     = "jccastro94/nieveinstantanea-landing"
}

variable "create_github_oidc_provider" {
  description = "false si la cuenta ya tiene el proveedor OIDC de GitHub Actions"
  type        = bool
  default     = true
}

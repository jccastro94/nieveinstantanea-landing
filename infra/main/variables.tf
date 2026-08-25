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
  # La cuenta 275459308785 YA tiene el proveedor OIDC de GitHub Actions: lo creó
  # el otro proyecto que comparte la cuenta. AWS solo permite uno por cuenta, así
  # que aquí se referencia el existente en vez de crear un duplicado.
  description = "true solo en una cuenta que AÚN no tenga el proveedor OIDC de GitHub"
  type        = bool
  default     = false
}

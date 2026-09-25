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

variable "github_oidc_subject_prefix" {
  # GitHub tiene activados los "immutable subject claims" en este repositorio,
  # así que el claim `sub` del token OIDC NO es "repo:owner/nombre" sino que
  # lleva los IDs numéricos inmutables del dueño y del repositorio:
  #
  #   repo:jccastro94@73132288/nieveinstantanea-landing@1337666342
  #
  # Esos IDs no cambian aunque se renombre la cuenta o el repositorio — ese es
  # justamente el punto de la función: que nadie pueda registrar el nombre
  # viejo y heredar este acceso a AWS.
  #
  # Para reobtenerlo:
  #   gh api repos/OWNER/REPO/actions/oidc/customization/sub
  description = "Prefijo del claim sub de GitHub OIDC (formato inmutable)"
  type        = string
  default     = "repo:jccastro94@73132288/nieveinstantanea-landing@1337666342"
}

# Despliegue — pasos de su lado

El sitio es estático (Astro → S3 + CloudFront). Toda la infraestructura es
Terraform (`infra/`) y todo despliegue pasa por GitHub Actions con OIDC —
no hay llaves de AWS guardadas en ningún lado.

## 0. Requisitos

- Cuenta de AWS con un usuario/rol administrador para el primer `apply`.
- [Terraform ≥ 1.10](https://developer.hashicorp.com/terraform/install) y
  [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) instalados.
- Credenciales locales: `aws configure` (o `aws configure sso`).

## 1. Estado de Terraform (una sola vez)

```bash
cd infra/bootstrap
terraform init
terraform apply
```

Crea el bucket `nieveinstantanea-terraform-state` (versionado y cifrado).
Si el nombre está tomado, cámbielo con `-var state_bucket_name=…` y actualice
el `backend "s3"` de `infra/main/versions.tf`.

## 2. Infraestructura principal

```bash
cd infra/main
terraform init
terraform apply
```

Crea: zona Route 53, certificado ACM (apex + www), bucket privado del sitio,
distribución CloudFront (HTTPS, HTTP/3, encabezados de seguridad, www→apex),
y el rol OIDC que GitHub Actions asume para desplegar.

> Nota: el certificado se valida por DNS dentro de la misma zona, pero la
> validación solo completa cuando el dominio ya apunta a Route 53 (paso 3).
> Si el primer `apply` se queda esperando en la validación del certificado,
> haga el paso 3 y vuelva a correr `terraform apply`.
>
> Si la cuenta ya tiene el proveedor OIDC de GitHub
> (`token.actions.githubusercontent.com`), aplique con
> `-var create_github_oidc_provider=false`.

## 3. Apuntar el dominio

`terraform output nameservers` muestra 4 servidores. En el registrador donde
compró `nieveinstantanea.com`, reemplace los nameservers por esos 4.
La propagación tarda de minutos a 48 h.

## 4. Variables en GitHub

En el repo → Settings → Secrets and variables → Actions → **Variables**:

| Variable | Valor |
|---|---|
| `AWS_DEPLOY_ROLE_ARN` | `terraform output deploy_role_arn` |
| `SITE_BUCKET` | `terraform output site_bucket` |
| `CLOUDFRONT_DISTRIBUTION_ID` | `terraform output cloudfront_distribution_id` |

(El workflow usa el environment `production`; se crea solo al primer deploy,
o créelo en Settings → Environments si quiere exigir aprobación manual.)

## 5. Primer despliegue

Push a `main` (o Actions → Deploy → Run workflow). El workflow construye,
sincroniza a S3 con los `Cache-Control` correctos e invalida CloudFront.
Antes de que el dominio propague puede probar con
`terraform output cloudfront_domain`.

## 6. Google Analytics 4

1. Cree la propiedad GA4 en [analytics.google.com](https://analytics.google.com)
   (flujo de datos web → `https://nieveinstantanea.com`).
2. Copie el ID de medición (`G-XXXXXXXXXX`) en `ga4MeasurementId` de
   `src/data/site.json` y haga push.
   Con el campo vacío el sitio no carga ningún script de analítica.
3. En GA4 → Administrar → Vinculación con Search Console, vincule también
   [Search Console](https://search.google.com/search-console) (verifique el
   dominio con el registro DNS TXT que Google le dé — se agrega en Route 53).

## Pendientes señalados en el handoff (antes de lanzar)

- [ ] **Verificar los URL de las 5 cadenas** en `src/data/retailers.json` —
      se pusieron por dominio conocido y no están confirmados.
- [ ] Fotografía profesional (packshot de Nieve Artificial y textura).
- [ ] Sustituir el wordmark tipográfico si aparece el logo vectorial oficial.

## Costos estimados

Route 53: ~$0.50/mes por la zona. S3 + CloudFront para un sitio de este
tamaño con tráfico de temporada: normalmente **< $5/mes** (el primer año
casi todo cae en la capa gratuita). El certificado ACM es gratis.

# nieveinstantanea-landing

Landing de **[nieveinstantanea.com](https://nieveinstantanea.com)** — nieve
artificial para decoración navideña, hecha en Costa Rica.

## Stack

- **[Astro 5](https://astro.build)**, salida 100 % estática. Cero JavaScript
  obligatorio: la página completa funciona con JS deshabilitado (el acordeón
  de preguntas usa `<details>` nativo; el único script es GA4, opcional).
- **Contenido en archivos**: todo texto e imagen editable vive en JSON bajo
  [`src/data/`](src/data), validado con Zod al construir.
  Guía: [docs/CONTENT.md](docs/CONTENT.md).
- **Sistema de diseño**: tokens en [`src/styles/tokens.css`](src/styles/tokens.css)
  (fuente: carpeta `Nieveinstantanea design system/`, que es la referencia de
  diseño hi-fi — no se sirve en producción).
- **Imágenes**: `astro:assets` genera AVIF/WebP + JPG de respaldo en varios
  tamaños. Fuentes convertidas a woff2 (`npm run fonts` para regenerar).
- **SEO/LLM**: sitemap, `robots.txt`, `llms.txt`, Open Graph, JSON-LD
  (Organization, Product ×4, FAQPage), canonical, favicon.
- **Infraestructura**: Terraform en [`infra/`](infra) — S3 privado +
  CloudFront (OAC), Route 53, ACM, rol OIDC para GitHub Actions.
  Guía: [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md).
- **CI/CD**: [`.github/workflows/ci.yml`](.github/workflows/ci.yml) valida
  PRs; [`deploy.yml`](.github/workflows/deploy.yml) publica `main` a S3 e
  invalida CloudFront. Sin llaves de AWS: OIDC.

## Desarrollo

```bash
npm install
npm run dev      # http://localhost:4321
npm run check    # tipos + validación de contenido
npm run build    # sitio final en dist/
npm run preview  # sirve dist/
```

## Estructura

```
src/
├── data/            ← TODO el contenido editable (ver docs/CONTENT.md)
├── assets/          ← imágenes optimizadas por el build
├── components/      ← una sección de la landing por componente
├── layouts/Base.astro  ← <head>: meta, OG, JSON-LD, fuentes, GA4
├── lib/             ← validación (content.ts), contacto, imágenes, schema.org
├── pages/           ← index.astro, 404.astro
└── styles/          ← tokens.css (sistema de diseño) + global.css
public/              ← fuentes woff2, robots.txt, llms.txt, favicons, og.jpg
infra/               ← Terraform (bootstrap del estado + stack principal)
docs/                ← CONTENT.md (editar contenido) · DEPLOYMENT.md (AWS)
```

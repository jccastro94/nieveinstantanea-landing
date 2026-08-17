# Cómo editar el contenido del sitio

No hay CMS: **todo el texto y las imágenes viven en archivos JSON** dentro de
`src/data/`. Editar el sitio = editar un JSON, hacer commit y push a `main`.
GitHub Actions reconstruye y publica solo (2–3 minutos).

Cada archivo se **valida al construir**: si borra una llave o deja un campo
vacío, el build falla con un mensaje que dice exactamente qué archivo y campo
está mal — nunca se publica una página rota.

## ¿Dónde está cada cosa?

| Quiero cambiar… | Archivo |
|---|---|
| WhatsApp, correo, mensajes de WhatsApp, ID de GA4, copos de nieve on/off | `src/data/site.json` |
| Título y descripción que salen en Google | `src/data/site.json` (`titulo`, `descripcion`) |
| Menú y botón del encabezado | `src/data/sections/header.json` |
| Titular, bajada, botones y chips del hero | `src/data/sections/hero.json` |
| Los 3 pasos de "Cómo funciona" | `src/data/sections/como.json` |
| Productos (nombres, descripciones, datos, fotos) | `src/data/products.json` |
| Bloque "¿La roja o la azul?" | `src/data/products.json` (`comparativo`) |
| Las 8 ideas para decorar | `src/data/sections/ideas.json` |
| Cadenas donde se vende (orden = jerarquía) | `src/data/retailers.json` |
| Preguntas frecuentes | `src/data/faq.json` |
| Texto de "Nosotros" | `src/data/sections/nosotros.json` |
| Banda de mayoreo | `src/data/sections/mayoreo.json` |
| Pie de página | `src/data/sections/footer.json` |

## Cambiar una foto

1. Copie la imagen nueva (JPG o PNG, horizontal, ~1200–1400 px de lado mayor)
   a `src/assets/`.
2. En el JSON correspondiente, cambie el campo `foto` por el nombre del
   archivo nuevo y actualice `fotoAlt` (descripción para accesibilidad).
3. Si la proporción de la foto cambió, actualice `fotoRatio`
   (p. ej. `"1400/1027"`) para que la caja no recorte el producto.

El build convierte automáticamente a AVIF/WebP y genera varios tamaños; no
hay que optimizar nada a mano.

## Campos que terminan en `Html`

Aceptan un mínimo de HTML: `<strong>` para negrita y `<a href="#seccion">`
para enlaces internos. Nada más.

## Contacto en UN solo lugar

El número de WhatsApp, el correo y los dos mensajes prellenados viven solo
en `src/data/site.json`. Los enlaces `wa.me`, `tel:` y `mailto:` se generan
de ahí — no los escriba en ningún otro archivo.

## Agregar / quitar elementos

- **Producto**: duplique un bloque en `productos` de `products.json`. `id`
  único; `familia` es `instantanea` (botón rojo) o `artificial` (botón azul);
  `fotoAjuste` es `cover` (foto ambiental) o `contain-hueso` / `contain-azul`
  (packshot sobre fondo plano).
- **Pregunta**: agregue `{ "pregunta": …, "respuestaHtml": … }` a `faq.json`.
  El schema de FAQ para Google se actualiza solo.
- **Cadena**: agregue nombre, URL y logo (PNG en `src/assets/`) a
  `retailers.json`. El orden del arreglo es el orden en pantalla.

## Probar antes de publicar

```bash
npm install
npm run dev        # http://localhost:4321 con recarga en vivo
npm run build      # valida el contenido y construye el sitio final
```

Si prefiere no instalar nada: edite el JSON directamente en github.com
(ícono de lápiz), el CI valida el cambio y, al hacer merge a `main`, se
publica solo.

# Handoff — Nieve Instantánea · Landing + sistema de diseño

## Qué es esto

El sitio de **nieveinstantanea.com**: una landing dirigida al **consumidor final**, con una vía visible para que tiendas y empresas pidan cotización de mayoreo. Español de Costa Rica, mobile-first.

**Los archivos `.dc.html` de `/design` son referencias de diseño, no código de producción.** Son prototipos en HTML que muestran el aspecto y el comportamiento buscados. La tarea es **recrear estos diseños en el entorno del proyecto** (HTML estático, Astro, Next, lo que se elija) siguiendo sus patrones. No copie el HTML tal cual: usa un runtime propio del entorno de diseño (`support.js`) que no debe llegar a producción.

**Fidelidad: alta (hi-fi).** Colores, tipografía, espaciado e interacciones son finales. Recréelos con precisión.

### Requisito explícito del cliente
Nada de CMS ni editores WYSIWYG. El sitio debe poder mantenerse editando archivos a mano. HTML estático + un `tokens.css` es exactamente lo que se busca. Hosting: **AWS (S3 + CloudFront)** o **Replit** — sin definir aún; el sitio debe ser estático puro para que ambos funcionen.

---

## Archivos de este paquete

```
handoff-nieveinstantanea/
├── README.md                      ← este documento
├── tokens.css                     ← COPIAR TAL CUAL: variables CSS + @font-face
├── fonts/
│   ├── Sunday-Regular.otf         ← display (titulares). Convertir a woff2.
│   ├── Arimo-Regular.ttf          ← texto e interfaz. Convertir a woff2.
│   └── Arimo-Bold.ttf
├── assets/                        ← todas las imágenes que usa la landing, ya redimensionadas
└── design/
    ├── Landing.dc.html            ← la landing completa (referencia)
    ├── Sistema de Diseño.dc.html  ← especímenes de tokens y componentes (referencia)
    └── support.js                 ← runtime del entorno de diseño. NO va a producción.
```

---

## Tokens de diseño

Todo está en **`tokens.css`**, listo para copiar. Resumen:

### Color

Dos familias de producto. **El color identifica el producto**, no es decoración.

| Token | Hex | Uso |
|---|---|---|
| `--ni-rojo` | `#C4211E` | Rojo de la etiqueta. Relleno de **todo** botón y badge. Blanco encima = 5.86:1 ✅ |
| `--ni-rojo-hover` | `#8E1512` | Hover de botones rojos |
| `--ni-rojo-texto` | `#B81D1A` | Texto rojo chico sobre blanco o hueso |
| `--ni-rojo-display` | `#E8342E` | **Solo** Sunday 24px+ y adornos. Nunca detrás de texto chico (4.23:1 ❌) |
| `--ni-rojo-claro` | `#FF6B62` | Texto rojo chico sobre negro (6.73:1 ✅) |
| `--ni-azul` | `#0050B6` | Familia **Nieve Artificial**. Botones y chips de ese producto |
| `--ni-azul-hover` | `#003C8A` | Hover; también texto azul chico |
| `--ni-azul-fondo` | `#EAF0FA` | Fondo de bloques y packshots de Nieve Artificial |
| `--ni-negro` | `#111213` | Tinta, marcos, secciones oscuras |
| `--ni-negro-pie` | `#0A0A0B` | Solo el pie de página |
| `--ni-blanco` | `#FFFFFF` | Fondo principal |
| `--ni-hueso` | `#F4F2EF` | Secciones alternas y campos |
| `--ni-gris` | `#5C6064` | Texto secundario. AA sobre blanco **y** sobre hueso |
| `--ni-verde` | `#1F6B3B` | Sellos de confianza, filete de testimonios, punto del botón de WhatsApp |
| `--ni-oro` | `#C9A227` | Badges destacados y filetes. Máx. 5 % de la página |

**Reglas de color que no se rompen:**
- Proporción de página: ~70 % blanco · 20 % negro · 8 % rojo · 2 % verde/oro. Si el rojo pasa del 25 % se ve barato.
- Rojo = Nieve Instantánea (crece con agua). Azul = Nieve Artificial (lista para usar). El azul **solo** aparece en lo que pertenece a ese producto; nunca como color de interfaz general.
- Todo el texto debe pasar **WCAG AA**. Esto ya costó dos rondas de corrección: no use `--ni-rojo-display` como fondo de texto chico ni gris más claro que `#5C6064` sobre hueso.

### Tipografía

- **Sunday** (`400`) — display. Titulares, cifras grandes, wordmark, numerales 01/02/03. **Nunca** en párrafos, botones, etiquetas ni texto bajo 24px.
- **Arimo** (`400`/`700`) — todo el texto, la interfaz y los botones.

| Token | Tamaño | Uso |
|---|---|---|
| `--ni-display-1` | `clamp(44px, 7vw, 96px)` | h1 del hero · Sunday · `line-height: 1.06` |
| `--ni-display-2` | `clamp(34px, 5vw, 64px)` | h2 de sección · Sunday · `1.02` |
| `--ni-display-3` | `clamp(24px, 2.8vw, 34px)` | h3 destacado · Sunday · `1.05` |
| `--ni-titulo` | `clamp(17px, 1.7vw, 21px)` | h3 de tarjeta · Arimo 700 · `1.25` |
| `--ni-cuerpo` | `clamp(15px, 1.4vw, 18px)` | Texto de sección · Arimo 400 · `1.65` |
| `--ni-cuerpo-sm` | `clamp(13.5px, 1.3vw, 15px)` | Texto de tarjeta · Arimo 400 · `1.6` |
| `--ni-etiqueta` | `clamp(10px, 1vw, 12px)` | Eyebrow · Arimo 700 · `letter-spacing: .16em` · MAYÚSCULAS |
| `--ni-boton` | `clamp(14px, 1.3vw, 17px)` | Arimo 700 |

Medida máxima de línea: **68 caracteres** (`max-width: 60ch` en bloques de texto).

### Espacio, radios y sombras

Escala de 4: `4 · 8 · 12 · 16 · 24 · 32 · 48 · 64`.
Márgenes de página `clamp(20px, 4vw, 64px)`; contenido máx. `1200px` (FAQ `860px`); padding vertical de sección `clamp(48px, 7vw, 104px)`.
Radios: chip `4px` · campo `6px` · tarjeta `10px` · foto `12px` · pill `999px`.
Sombras: `--ni-sombra-1` para tarjetas, `--ni-sombra-2` para fotos destacadas.

---

## Componentes

### Botones
Altura mínima **48px** (52–54px en CTA principales), `border-radius: 999px`, Arimo 700.
- **Primario:** fondo `--ni-rojo`, texto blanco. Hover → `--ni-rojo-hover`. Transición `.15s ease`.
- **Primario azul:** igual pero `--ni-azul` / `--ni-azul-hover`. Solo para Nieve Artificial.
- **Secundario:** transparente, `2px solid` (negro sobre claro, `rgba(255,255,255,.55)` sobre oscuro).
- **Sobre fondo rojo:** fondo blanco, texto `--ni-rojo-hover`; hover invierte a negro.
- Los botones de WhatsApp llevan un punto de 8–9px `--ni-verde` (o `#8FF0A8` sobre fondo oscuro) antes del texto.
- **Un solo botón rojo por pantalla visible.**

### Tarjeta de producto
`border: 2px solid #111213` (la firma de la marca, tomada del empaque) · radio `10px` · foto `aspect-ratio: 4/3`.
Orden interno: chip de familia → `h3` → descripción → tabla de 2 datos → botón.
Packshots sobre fondo plano (`--ni-hueso` o `--ni-azul-fondo`) usan `object-fit: contain` + borde inferior de 2px; las fotos ambientales usan `cover`.

### Chips
Radio `4px`, Arimo 700 `10–11px`, `letter-spacing: .06–.08em`.
`CRECE CON AGUA` (rojo tenue/`#8E1512`) · `LISTA PARA USAR` (azul sólido/blanco) · `EL FAVORITO` (oro/negro) · `NUEVO` (azul tenue).

### Campos
Fondo blanco sobre bloque hueso, `border: 1.5px solid rgba(17,18,19,.18)`, radio `6px`, foco en rojo.

### Acordeón (FAQ)
`<details>`/`<summary>` nativo, `1.5px` de borde, radio `8px`. El `+` rota 45° al abrir. **No use JS para esto.**

### Testimonio
Filete izquierdo de `3px` en `--ni-verde` sobre fondo hueso. Nunca rojo.

---

## Estructura de la landing

Orden de secciones (cada `<section>` con `id` y `scroll-margin-top: 112px`):

1. **`header`** — sticky. Barra roja con wordmark Sunday + CTA "Dónde comprarla"; debajo, nav negra con scroll horizontal en móvil. El enlace **Mayoreo** va en `--ni-rojo-claro` para distinguirlo.
2. **`#top` Hero** — 2 columnas: panel negro con h1 + bajada + 2 CTA + 3 chips | foto a proporción nativa. Copos animados solo aquí.
3. **`#como` Cómo funciona** — 3 pasos numerados en Sunday rojo + foto. Nota verde al pie.
4. **`#productos`** — 4 tarjetas + bloque comparativo "¿Cuál me conviene?" (rojo vs azul).
5. **`#ideas`** — sección negra, cuadrícula de 8 usos con foto.
6. **`#donde`** — sección roja: 5 logos de cadena enlazados + foto + WhatsApp de respaldo.
7. **`#preguntas`** — 7 entradas de acordeón, ancho `860px`.
8. **`#nosotros`** — texto + foto de TV.
9. **`#mayoreo`** — banda negra compacta: la única sección B2B. WhatsApp con mensaje distinto.
10. **`footer`** — 3 columnas sobre `--ni-negro-pie`.

### Responsive
Sin media queries salvo `prefers-reduced-motion`. Todo con `clamp()` y `grid-template-columns: repeat(auto-fit, minmax(min(100%, Npx), 1fr))`.

⚠️ **Cuidado con el piso de `minmax`:** debe permitir el número de columnas buscado al ancho de contenido de 1072px. La fila de 5 logos usa `148px`; con `200px` colapsaba a 4+1. Y **no meta el titular dentro de la misma retícula que las tarjetas** — desalinea las filas.

⚠️ **No use `overflow-x: hidden` en el contenedor raíz** — promueve `overflow-y` a `auto` y rompe el `position: sticky` del header. Use `overflow-x: clip`.

---

## Interacciones

- **Hover** de botones y enlaces: `.15s ease`. Las tarjetas de cadena suben 2px con sombra.
- **Copos del hero:** 4 `<span>` absolutos con `animation: ni-fall` de 9–12s y delays escalonados. Solo en el hero.
- **FAQ:** `<details>` nativo, sin JS.
- **`prefers-reduced-motion: reduce`** apaga toda animación y transición. Ya está en `tokens.css`.
- **Sin JS obligatorio.** La página funciona completa con JS deshabilitado. No introduzca un framework que rompa eso.

---

## Contacto y enlaces

- **WhatsApp:** `+506 7180-5080` → `https://wa.me/50671805080?text=<mensaje>`
  Dos mensajes distintos según el origen, para que el cliente sepa quién escribe:
  - Consumidor: `Hola, quiero saber dónde comprar Nieve Instantánea.`
  - Mayoreo: `Hola, quiero cotizar Nieve Instantánea al mayoreo.`
- **Correo:** `jcastro@bbslimitada.com`
- **Teléfono:** `tel:+50671805080`

Manténgalos en **un solo lugar** (constante o data file). En el prototipo son props; en el sitio deben ser una variable, no texto repetido en 12 sitios.

### Cadenas donde se vende (temporada 2026)
Socios principales primero: **Sol Naciente**, **Auto Mercado**, **Almacenes El Rey**; luego **MegaSuper** y **EPA**.
Las cinco tarjetas son idénticas en tamaño — la jerarquía la da el orden, no la escala.

⚠️ **Los URL de las cadenas se pusieron por dominio conocido y NO están verificados.** Confírmelos antes de publicar (sobre todo Sol Naciente y El Rey).

---

## Catálogo

Nombres y descripciones **oficiales del cliente** — no los reescriba:

| Producto | Descripción | Datos |
|---|---|---|
| Bolsa Doypack Metalizada | Nieve Instantánea en polvo: al agregar agua se convierte en nieve | 100 gr · agua 1.5 L |
| Frasco plástico con tapa de corcho | Nieve Instantánea en polvo: al agregar agua se convierte en nieve | 100 gr · agua 1.5 L |
| Kit Huellas de Santa | 3 piezas: 2 plantillas (huella de Santa / huella de reno y elfo) + 1 bolsa de 50 gr de Nieve Instantánea | 2 plantillas · 50 gr |
| Nieve Artificial Bolsa Doypack | Nieve Artificial con figuras de copo de nieve. Lista para usar, sin agua | 200 gr · sin preparación |

Código de barras de Nieve Artificial: `07443031150055`.
Atributos verificados: **+200 % de volumen**, inodora, hipoalergénica, reutilizable, registro sanitario. Pyme costarricense desde 2018.

---

## Imágenes

Todas en `/assets`, ya redimensionadas a ~1200–1400px de lado mayor y 60–260 KB. Sirven tal cual.

**Recomendaciones de implementación:**
- Convertir a **WebP/AVIF** con `<picture>` y fallback JPG.
- El hero es la única con `loading="eager"`; todas las demás `loading="lazy"` + `decoding="async"`.
- **Fije la proporción de la caja a la de la foto** (p. ej. `aspect-ratio: 1400/805`) en las fotos grandes. Todas las tomas son horizontales (~1.36–1.74); si la caja queda más alta, `object-fit: cover` recorta el producto. Este error ya se corrigió dos veces.
- Las fotos con `alt` descriptivo en español ya están escritas en el prototipo: cópielas.

**Pendiente del cliente:** falta una tanda de fotografía profesional con fondo y luz consistentes. Las actuales son una mezcla de sesión de producto y fotos de celular. El packshot de Nieve Artificial y la foto de textura desentonan con la línea roja.

---

## Trabajo pendiente

1. **Verificar los URL de las cinco cadenas.**
2. **Fotografía profesional** — packshot de Nieve Artificial y fotos de uso con fondo consistente.
3. **Logo oficial en vectorial** — el wordmark actual es tipografía Sunday. Si existe un `.ai`/`.svg` del logo dibujado a mano, sustitúyalo.
4. **Blog** — el cliente lo quiere como galería de producto (odia las galerías tradicionales). No está diseñado aún.
5. **Páginas por producto** y **página de retailers/corporativo** — no diseñadas aún. El material B2B (consignación 100 %, factura electrónica, código de barras, demo en punto de venta) se retiró de la landing y vive listo para esa página.
6. **SEO/meta** — el `<title>` y la `meta description` están en el prototipo. Faltan Open Graph, favicon y `schema.org/Product`.
7. **Decidir hosting** (AWS S3+CloudFront o Replit) y montar despliegue.

---

## Tono de voz

Usted, cálido y concreto. La magia se menciona una vez por página, no en cada sección.

**Sí:** "Solo agrega agua y… ¡magia!" · "Nieve de verdad en un minuto" · "¿No la encuentra? ¡Escríbanos!"
**No:** "Soluciones integrales de decoración estacional" · "La mejor nieve del mercado" · signos de exclamación en cadena.

Números siempre con cifra y unidad: 200 %, 1.5 L, 100 gr.

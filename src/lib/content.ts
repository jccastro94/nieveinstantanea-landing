/**
 * Capa de contenido: valida los JSON de src/data con Zod al construir.
 * Si un JSON queda mal editado, `astro build` falla con un error legible
 * en lugar de publicar una página rota.
 */
import { z } from 'astro/zod';

import siteJson from '../data/site.json';
import headerJson from '../data/sections/header.json';
import heroJson from '../data/sections/hero.json';
import comoJson from '../data/sections/como.json';
import productsJson from '../data/products.json';
import ideasJson from '../data/sections/ideas.json';
import retailersJson from '../data/retailers.json';
import faqJson from '../data/faq.json';
import nosotrosJson from '../data/sections/nosotros.json';
import mayoreoJson from '../data/sections/mayoreo.json';
import footerJson from '../data/sections/footer.json';

const enlace = z.object({ texto: z.string().min(1), href: z.string().min(1) });
const foto = {
  foto: z.string().min(1),
  fotoAlt: z.string().min(1),
};

const siteSchema = z.object({
  nombre: z.string().min(1),
  titulo: z.string().min(1).max(80),
  descripcion: z.string().min(1).max(170),
  url: z.string().url(),
  whatsapp: z.string().min(1),
  codigoPais: z.string().regex(/^\d+$/),
  correo: z.string().email(),
  mensajeWhatsappConsumidor: z.string().min(1),
  mensajeWhatsappMayoreo: z.string().min(1),
  ga4MeasurementId: z.string().regex(/^(G-[A-Z0-9]+)?$/, 'Debe ser un ID tipo G-XXXXXXXXXX o quedar vacío'),
  ogImage: z.string().min(1),
  mostrarNieve: z.boolean(),
  anioFundacion: z.number().int(),
  gtinNieveArtificial: z.string().regex(/^\d{14}$/),
});

const headerSchema = z.object({
  cta: enlace,
  nav: z.array(enlace.extend({ destacado: z.boolean().optional() })).min(1),
});

const heroSchema = z.object({
  badge: z.string().min(1),
  titulo: z.string().min(1),
  bajadaHtml: z.string().min(1),
  ctaPrimario: enlace,
  ctaSecundario: enlace,
  chips: z.array(z.object({ texto: z.string().min(1), verde: z.boolean().optional() })),
  ...foto,
  fotoRatio: z.string().regex(/^\d+\s*\/\s*\d+$/),
});

const comoSchema = z.object({
  eyebrow: z.string().min(1),
  titulo: z.string().min(1),
  pasos: z.array(z.object({ titulo: z.string().min(1), texto: z.string().min(1) })).length(3),
  nota: z.string().min(1),
  ...foto,
  fotoRatio: z.string().regex(/^\d+\s*\/\s*\d+$/),
});

const chipEstilo = z.enum(['rojo-tenue', 'oro', 'azul', 'azul-tenue']);
const productsSchema = z.object({
  eyebrow: z.string().min(1),
  titulo: z.string().min(1),
  productos: z
    .array(
      z.object({
        id: z.string().min(1),
        nombre: z.string().min(1),
        descripcion: z.string().min(1),
        familia: z.enum(['instantanea', 'artificial']),
        chips: z.array(z.object({ texto: z.string().min(1), estilo: chipEstilo })).min(1),
        ...foto,
        fotoAjuste: z.enum(['cover', 'contain-hueso', 'contain-azul']),
        datos: z.array(z.object({ etiqueta: z.string().min(1), valor: z.string().min(1) })).length(2),
      })
    )
    .min(1),
  comparativo: z.object({
    titulo: z.string().min(1),
    bajada: z.string().min(1),
    opciones: z
      .array(
        z.object({
          familia: z.enum(['instantanea', 'artificial']),
          titulo: z.string().min(1),
          texto: z.string().min(1),
        })
      )
      .length(2),
  }),
});

const ideasSchema = z.object({
  eyebrow: z.string().min(1),
  titulo: z.string().min(1),
  ideas: z
    .array(
      z.object({
        titulo: z.string().min(1),
        textoHtml: z.string().min(1),
        ...foto,
        fotoPosicion: z.string().optional(),
        chip: z.string().optional(),
      })
    )
    .min(1),
  notaHtml: z.string().min(1),
});

const retailersSchema = z.object({
  titulo: z.string().min(1),
  bajada: z.string().min(1),
  cadenas: z
    .array(z.object({ nombre: z.string().min(1), url: z.string().url(), logo: z.string().min(1) }))
    .min(1),
  ...foto,
  fotoRatio: z.string().regex(/^\d+\s*\/\s*\d+$/),
  fotoPie: z.string().min(1),
  respaldo: z.object({
    pregunta: z.string().min(1),
    boton: z.string().min(1),
    notaHtml: z.string().min(1),
  }),
});

const faqSchema = z.object({
  eyebrow: z.string().min(1),
  titulo: z.string().min(1),
  preguntas: z
    .array(z.object({ pregunta: z.string().min(1), respuestaHtml: z.string().min(1) }))
    .min(1),
});

const nosotrosSchema = z.object({
  eyebrow: z.string().min(1),
  titulo: z.string().min(1),
  texto: z.string().min(1),
  ...foto,
  fotoRatio: z.string().regex(/^\d+\s*\/\s*\d+$/),
});

const mayoreoSchema = z.object({
  eyebrow: z.string().min(1),
  titulo: z.string().min(1),
  texto: z.string().min(1),
  botonCotizar: z.string().min(1),
  botonLlamar: z.string().min(1),
});

const footerSchema = z.object({
  descripcion: z.string().min(1),
  columnaSitio: z.object({ titulo: z.string().min(1), enlaces: z.array(enlace).min(1) }),
  columnaContacto: z.object({ titulo: z.string().min(1), ubicacion: z.string().min(1) }),
  derechos: z.string().min(1),
});

function parse<T extends z.ZodTypeAny>(schema: T, data: unknown, archivo: string): z.infer<T> {
  const result = schema.safeParse(data);
  if (!result.success) {
    const detalle = result.error.issues
      .map((i) => `  · ${i.path.join('.')}: ${i.message}`)
      .join('\n');
    throw new Error(`Contenido inválido en src/data/${archivo}:\n${detalle}`);
  }
  return result.data;
}

export const site = parse(siteSchema, siteJson, 'site.json');
export const header = parse(headerSchema, headerJson, 'sections/header.json');
export const hero = parse(heroSchema, heroJson, 'sections/hero.json');
export const como = parse(comoSchema, comoJson, 'sections/como.json');
export const products = parse(productsSchema, productsJson, 'products.json');
export const ideas = parse(ideasSchema, ideasJson, 'sections/ideas.json');
export const retailers = parse(retailersSchema, retailersJson, 'retailers.json');
export const faq = parse(faqSchema, faqJson, 'faq.json');
export const nosotros = parse(nosotrosSchema, nosotrosJson, 'sections/nosotros.json');
export const mayoreo = parse(mayoreoSchema, mayoreoJson, 'sections/mayoreo.json');
export const footer = parse(footerSchema, footerJson, 'sections/footer.json');

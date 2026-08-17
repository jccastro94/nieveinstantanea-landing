/**
 * Datos estructurados (schema.org) generados desde el contenido.
 */
import { site, products, faq } from './content';
import { contacto } from './contact';
import { foto } from './images';

const sinHtml = (html: string) => html.replace(/<[^>]+>/g, '');
const absoluta = (ruta: string) => new URL(ruta, site.url).href;

export function datosEstructurados(): object[] {
  const organizacion = {
    '@context': 'https://schema.org',
    '@type': 'Organization',
    name: site.nombre,
    url: site.url,
    email: site.correo,
    foundingDate: String(site.anioFundacion),
    address: { '@type': 'PostalAddress', addressCountry: 'CR' },
    contactPoint: {
      '@type': 'ContactPoint',
      contactType: 'customer service',
      url: contacto.waLink,
      email: site.correo,
      availableLanguage: 'es',
    },
  };

  const productos = products.productos.map((p) => ({
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: p.nombre,
    description: p.descripcion,
    image: absoluta(foto(p.foto).src),
    brand: { '@type': 'Brand', name: site.nombre },
    countryOfOrigin: 'CR',
    ...(p.id === 'artificial' ? { gtin: site.gtinNieveArtificial } : {}),
  }));

  const preguntas = {
    '@context': 'https://schema.org',
    '@type': 'FAQPage',
    mainEntity: faq.preguntas.map((q) => ({
      '@type': 'Question',
      name: q.pregunta,
      acceptedAnswer: { '@type': 'Answer', text: sinHtml(q.respuestaHtml) },
    })),
  };

  const sitioWeb = {
    '@context': 'https://schema.org',
    '@type': 'WebSite',
    name: site.nombre,
    url: site.url,
    inLanguage: 'es-CR',
  };

  return [organizacion, sitioWeb, ...productos, preguntas];
}

/**
 * Enlaces de contacto derivados de src/content/site.json.
 * ÚNICO lugar donde se construyen: no repita el número en componentes.
 */
import { site } from './content';

const digitos = (site.codigoPais + site.whatsapp).replace(/\D/g, '');

const wa = (mensaje: string) => `https://wa.me/${digitos}?text=${encodeURIComponent(mensaje)}`;

export const contacto = {
  whatsapp: site.whatsapp,
  correo: site.correo,
  telLink: `tel:+${digitos}`,
  mailLink: `mailto:${site.correo}`,
  waLink: wa(site.mensajeWhatsappConsumidor),
  waMayoreoLink: wa(site.mensajeWhatsappMayoreo),
} as const;

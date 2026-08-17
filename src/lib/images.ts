/**
 * Resuelve nombres de imagen del contenido (p. ej. "IMG_2923-web.jpg")
 * a los módulos optimizados por astro:assets en src/assets.
 */
import type { ImageMetadata } from 'astro';

const modulos = import.meta.glob<{ default: ImageMetadata }>('../assets/*.{jpg,png}', {
  eager: true,
});

export function foto(nombre: string): ImageMetadata {
  const modulo = modulos[`../assets/${nombre}`];
  if (!modulo) {
    const disponibles = Object.keys(modulos)
      .map((k) => k.replace('../assets/', ''))
      .join(', ');
    throw new Error(`Imagen "${nombre}" no existe en src/assets. Disponibles: ${disponibles}`);
  }
  return modulo.default;
}

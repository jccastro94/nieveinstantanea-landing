// Convierte las fuentes del sistema de diseño a woff2 (una sola vez; los
// resultados se versionan en public/fonts). Uso: npm run fonts
import { readFile, writeFile, mkdir } from 'node:fs/promises';
import path from 'node:path';
import wawoff2 from 'wawoff2';

const SRC = 'Nieveinstantanea design system/fonts';
const OUT = 'public/fonts';

const fonts = ['Sunday-Regular.otf', 'Arimo-Regular.ttf', 'Arimo-Bold.ttf'];

await mkdir(OUT, { recursive: true });
for (const file of fonts) {
  const input = await readFile(path.join(SRC, file));
  const woff2 = await wawoff2.compress(input);
  const outName = file.replace(/\.(otf|ttf)$/, '.woff2');
  await writeFile(path.join(OUT, outName), woff2);
  console.log(`${file} → ${outName} (${input.length} → ${woff2.length} bytes)`);
}

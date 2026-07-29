/*---------------------------------------------------------------
 *  Analyze Ravenwood Omarchy themes for WCAG contrast,
 *  gradient smoothness, hue consistency, and cross-file
 *  color consistency (colors.toml ↔ ravenwood.lua ↔ btop.theme).
 *
 *  Reads the actual theme files from the repo — no hardcoded
 *  palettes.  Run:  node scripts/analyze-contrast.mjs
 *--------------------------------------------------------------*/

import { readFileSync, readdirSync, existsSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, '..');

// ── Helpers ──

function hexToRgb(hex) {
  const raw = hex.replace('#', '');
  const h = raw.length === 8 ? raw.slice(0, 6) : raw; // strip 2-char alpha if present
  const full = h.length === 3
    ? h.split('').map(c => c + c).join('')
    : h.slice(0, 6);
  return {
    r: parseInt(full.slice(0, 2), 16),
    g: parseInt(full.slice(2, 4), 16),
    b: parseInt(full.slice(4, 6), 16),
  };
}

function relativeLuminance(r, g, b) {
  const [rs, gs, bs] = [r, g, b].map((c) => {
    const s = c / 255;
    return s <= 0.03928 ? s / 12.92 : ((s + 0.055) / 1.055) ** 2.4;
  });
  return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
}

function contrastRatio(hex1, hex2) {
  const c1 = hexToRgb(hex1);
  const c2 = hexToRgb(hex2);
  const l1 = relativeLuminance(c1.r, c1.g, c1.b);
  const l2 = relativeLuminance(c2.r, c2.g, c2.b);
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

function wcagRating(ratio) {
  if (ratio >= 7) return 'AAA ✓';
  if (ratio >= 4.5) return 'AA ✓';
  if (ratio >= 3) return 'AA-large ✓';
  return 'FAIL ✗';
}

function deltaE(hex1, hex2) {
  const c1 = hexToRgb(hex1);
  const c2 = hexToRgb(hex2);
  return Math.sqrt((c1.r - c2.r) ** 2 + (c1.g - c2.g) ** 2 + (c1.b - c2.b) ** 2);
}

function hueAngle(hex) {
  const c = hexToRgb(hex);
  const r = c.r / 255, g = c.g / 255, b = c.b / 255;
  const max = Math.max(r, g, b), min = Math.min(r, g, b);
  if (max === min) return -1;
  const d = max - min;
  let hue;
  if (max === r) hue = ((g - b) / d + (g < b ? 6 : 0)) * 60;
  else if (max === g) hue = ((b - r) / d + 2) * 60;
  else hue = ((r - g) / d + 4) * 60;
  return hue;
}

function saturation(hex) {
  const c = hexToRgb(hex);
  const r = c.r / 255, g = c.g / 255, b = c.b / 255;
  const max = Math.max(r, g, b), min = Math.min(r, g, b);
  const l = (max + min) / 2;
  if (max === min) return 0;
  const d = max - min;
  return l > 0.5 ? d / (2 - max - min) : d / (max + min);
}

function lightness(hex) {
  const c = hexToRgb(hex);
  const r = c.r / 255, g = c.g / 255, b = c.b / 255;
  const max = Math.max(r, g, b), min = Math.min(r, g, b);
  return (max + min) / 2;
}

// ── TOML parser (minimal — enough for colors.toml) ──

function parseColorsToml(filePath) {
  const text = readFileSync(filePath, 'utf8');
  const colors = {};
  for (const line of text.split('\n')) {
    const m = line.match(/^(\w+)\s*=\s*"(#[0-9a-fA-F]{6,8})"/);
    if (m) {
      colors[m[1]] = m[2];
    }
  }
  return colors;
}

// ── Extract hex colors from ravenwood.lua ──

function parseLuaColors(filePath) {
  const text = readFileSync(filePath, 'utf8');
  // Only parse from the `local colors = { ... }` block, not highlight definitions
  const blockMatch = text.match(/local colors\s*=\s*\{(.*?)\n\}/s);
  if (!blockMatch) return {};
  const block = blockMatch[1];
  const colors = {};
  const re = /\b(\w+)\s*=\s*"(#[0-9a-fA-F]{6})"/g;
  let m;
  while ((m = re.exec(block)) !== null) {
    colors[m[1]] = m[2];
  }
  return colors;
}

// ── Extract hex colors from btop.theme ──

function parseBtopColors(filePath) {
  const text = readFileSync(filePath, 'utf8');
  const colors = {};
  const re = /theme\[(\w+)\]="(#[0-9a-fA-F]{6})"/g;
  let m;
  while ((m = re.exec(text)) !== null) {
    colors[m[1]] = m[2];
  }
  return colors;
}

// ── Map colors.toml ANSI slots to semantic names ──

function tomlToSemantic(c) {
  return {
    bg: c.background,
    fg: c.foreground,
    accent: c.accent,
    cursor: c.cursor,
    selection_bg: c.selection_background,
    selection_fg: c.selection_foreground,
    // ANSI 16-color mapping
    black: c.color0,
    red: c.color1,
    green: c.color2,
    yellow: c.color3,
    blue: c.color4,
    magenta: c.color5,
    cyan: c.color6,
    white: c.color7,
    bright_black: c.color8,
    bright_red: c.color9,
    bright_green: c.color10,
    bright_yellow: c.color11,
    bright_blue: c.color12,
    bright_magenta: c.color13,
    bright_cyan: c.color14,
    bright_white: c.color15,
  };
}

// ── Analysis ──

function analyzeTheme(name, toml, isDark, luaColors) {
  const s = tomlToSemantic(toml);
  const realm = { name, isDark, issues: [], warnings: [], passes: [] };

  // 1. Primary text contrast (fg on bg)
  const fgOnBg = contrastRatio(s.fg, s.bg);
  realm.fgOnBg = fgOnBg;
  realm.fgOnBgRating = wcagRating(fgOnBg);
  if (fgOnBg < 4.5)
    realm.issues.push(`fg on bg contrast is ${fgOnBg.toFixed(2)} — below AA (4.5)`);
  else if (fgOnBg < 7)
    realm.warnings.push(`fg on bg contrast is ${fgOnBg.toFixed(2)} — AA but below AAA (7)`);
  else
    realm.passes.push(`fg on bg: ${fgOnBg.toFixed(2)} (AAA)`);

  // 2. Accent on bg (the hero color)
  const accentOnBg = contrastRatio(s.accent, s.bg);
  realm.accentOnBg = accentOnBg;
  if (accentOnBg < 3)
    realm.issues.push(`accent on bg contrast is ${accentOnBg.toFixed(2)} — below AA-large (3)`);
  else if (accentOnBg < 4.5)
    realm.warnings.push(`accent on bg contrast is ${accentOnBg.toFixed(2)} — AA-large but below AA (4.5)`);
  else
    realm.passes.push(`accent on bg: ${accentOnBg.toFixed(2)} (AA+)`);

  // 3. Cursor visibility (cursor on bg)
  const cursorOnBg = contrastRatio(s.cursor, s.bg);
  if (cursorOnBg < 3)
    realm.warnings.push(`cursor on bg: ${cursorOnBg.toFixed(2)} — may be hard to see`);
  else
    realm.passes.push(`cursor on bg: ${cursorOnBg.toFixed(2)}`);

  // 4. Selection contrast (fg-color on bg-color, inverted)
  const selContrast = contrastRatio(s.selection_bg, s.selection_fg);
  if (selContrast < 4.5)
    realm.issues.push(`selection contrast is ${selContrast.toFixed(2)} — below AA (4.5)`);
  else
    realm.passes.push(`selection contrast: ${selContrast.toFixed(2)} (AA)`);

  // 5. ANSI accent contrast on bg (dark 8 = dim variants)
  const ansiAccents = ['red', 'green', 'yellow', 'blue', 'magenta', 'cyan'];
  for (const acc of ansiAccents) {
    const r = contrastRatio(s[acc], s.bg);
    if (r < 3)
      realm.warnings.push(`ANSI ${acc} (${s[acc]}) on bg: ${r.toFixed(2)} — may not pop`);
    else
      realm.passes.push(`ANSI ${acc} on bg: ${r.toFixed(2)}`);
  }

  // 5b. Bright ANSI accent contrast on bg (bright 8 = full variants)
  for (const acc of ansiAccents) {
    const r = contrastRatio(s[`bright_${acc}`], s.bg);
    if (r < 3)
      realm.warnings.push(`bright_${acc} (${s[`bright_${acc}`]}) on bg: ${r.toFixed(2)} — may not pop`);
    else
      realm.passes.push(`bright_${acc} on bg: ${r.toFixed(2)}`);
  }

  // 5c. Black & bright_black contrast on bg
  // Dark themes: black is a bg-like color; low contrast is normal (warning if < 1.2)
  // Light themes: black is a TEXT color; must have good contrast (issue if < 3)
  const blackOnBg = contrastRatio(s.black, s.bg);
  const brightBlackOnBg = contrastRatio(s.bright_black, s.bg);
  if (isDark) {
    if (blackOnBg < 1.2)
      realm.warnings.push(`ANSI black (${s.black}) on bg: ${blackOnBg.toFixed(2)} — identical to bg`);
    else
      realm.passes.push(`black on bg: ${blackOnBg.toFixed(2)} (dark theme — bg-like)`);
    if (brightBlackOnBg < 1.2)
      realm.warnings.push(`ANSI bright_black (${s.bright_black}) on bg: ${brightBlackOnBg.toFixed(2)} — identical to bg`);
    else
      realm.passes.push(`bright_black on bg: ${brightBlackOnBg.toFixed(2)} (dark theme — bg-like)`);
  } else {
    if (blackOnBg < 3)
      realm.issues.push(`ANSI black (${s.black}) on bg: ${blackOnBg.toFixed(2)} — text would be nearly invisible on light bg`);
    else
      realm.passes.push(`black on bg: ${blackOnBg.toFixed(2)} (light theme — text-visible)`);
    if (brightBlackOnBg < 3)
      realm.issues.push(`ANSI bright_black (${s.bright_black}) on bg: ${brightBlackOnBg.toFixed(2)} — muted text would be invisible on light bg`);
    else
      realm.passes.push(`bright_black on bg: ${brightBlackOnBg.toFixed(2)} (light theme — text-visible)`);
  }

  // 5d. fg on secondary surfaces (dark_bg, light_bg)
  const luaParsed = luaColors && luaColors.dark_bg;
  if (luaParsed) {
    const fgOnDarkBg = contrastRatio(s.fg, luaColors.dark_bg);
    if (fgOnDarkBg < 4.5)
      realm.issues.push(`fg on dark_bg (${luaColors.dark_bg}): ${fgOnDarkBg.toFixed(2)} — below AA (4.5)`);
    else
      realm.passes.push(`fg on dark_bg: ${fgOnDarkBg.toFixed(2)}`);

    const fgOnLightBg = contrastRatio(s.fg, luaColors.light_bg);
    if (fgOnLightBg < 4.5)
      realm.issues.push(`fg on light_bg (${luaColors.light_bg}): ${fgOnLightBg.toFixed(2)} — below AA (4.5)`);
    else
      realm.passes.push(`fg on light_bg: ${fgOnLightBg.toFixed(2)}`);
  }

  // 6. Dim/bright distinction (skill recipe: dim for dark 8, full for bright 8)
  // The dim variants should be darker/desaturated vs the full (bright) variants.
  for (const acc of ansiAccents) {
    if (s[acc] === s[`bright_${acc}`]) {
      realm.warnings.push(`ANSI ${acc} == bright_${acc} (${s[acc]}) — no dim/bright distinction`);
    } else {
      const dimL = lightness(s[acc]);
      const brightL = lightness(s[`bright_${acc}`]);
      if (isDark && brightL <= dimL)
        realm.warnings.push(`bright_${acc} not brighter than dim ${acc} (dark theme)`);
      else if (!isDark && dimL >= brightL)
        realm.warnings.push(`dim ${acc} not darker than bright_${acc} (light theme)`);
    }
  }

  // 7. ANSI dim/bright distinction (dark 8 should differ from bright 8)
  let dimBrightSame = 0;
  for (const acc of ansiAccents) {
    if (s[acc] === s[`bright_${acc}`]) dimBrightSame++;
  }
  if (dimBrightSame === ansiAccents.length)
    realm.warnings.push('All ANSI accent pairs (dark 8 / bright 8) are identical — no dim/bright distinction');
  else if (dimBrightSame > 0)
    realm.passes.push(`${ansiAccents.length - dimBrightSame}/${ansiAccents.length} ANSI pairs have dim/bright distinction`);

  // 8. Background gradient smoothness — only compare actual bg-like colors.
  //    On light themes, color0/color8 are dark (text colors), not bg colors,
  //    so they should NOT be in the bg ramp.
  const bgL = lightness(s.bg);
  const bgRamp = [
    ['bg', s.bg],
    ['black (color0)', s.black],
    ['bright_black (color8)', s.bright_black],
  ].filter(([, h]) => {
    if (!h) return false;
    const l = lightness(h);
    // Only include if within 0.15 lightness of bg (i.e. it's a bg-like color)
    return Math.abs(l - bgL) < 0.15;
  });
  for (let i = 0; i < bgRamp.length - 1; i++) {
    const [aName, aHex] = bgRamp[i];
    const [bName, bHex] = bgRamp[i + 1];
    const d = deltaE(aHex, bHex);
    if (d < 5)
      realm.warnings.push(`${aName}→${bName} deltaE=${d.toFixed(1)} — very close, may not be distinguishable`);
    // Light themes have a naturally wider bg range (cream → tan); use a higher threshold
    else if (d > (isDark ? 40 : 55))
      realm.warnings.push(`${aName}→${bName} deltaE=${d.toFixed(1)} — large jump`);
  }

  // 9. Background hue consistency
  const bgHues = bgRamp.map(([, h]) => hueAngle(h)).filter((h) => h >= 0);
  if (bgHues.length > 1) {
    const avgHue = bgHues.reduce((a, b) => a + b, 0) / bgHues.length;
    const maxDev = Math.max(...bgHues.map((h) => Math.abs(h - avgHue)));
    if (maxDev > 30)
      realm.warnings.push(`Background hue deviation: ${maxDev.toFixed(0)}° (avg ${avgHue.toFixed(0)}°)`);
    else
      realm.passes.push(`Background hue consistent: avg ${avgHue.toFixed(0)}°, max dev ${maxDev.toFixed(0)}°`);
  }

  // 10. fg tint check (not pure white/black)
  const fgRgb = hexToRgb(s.fg);
  if (isDark && fgRgb.r >= 250 && fgRgb.g >= 250 && fgRgb.b >= 250)
    realm.issues.push('fg is near-pure white — should be warm-tinted');
  else if (!isDark && fgRgb.r <= 5 && fgRgb.g <= 5 && fgRgb.b <= 5)
    realm.issues.push('fg is near-pure black — should be cool-tinted');
  else
    realm.passes.push(`fg is tinted (r=${fgRgb.r} g=${fgRgb.g} b=${fgRgb.b})`);

  // 11. bg tint check (not neutral grey)
  const bgRgb = hexToRgb(s.bg);
  const bgRange = Math.max(bgRgb.r, bgRgb.g, bgRgb.b) - Math.min(bgRgb.r, bgRgb.g, bgRgb.b);
  if (bgRange < 3)
    realm.issues.push(`bg is nearly neutral grey (r=${bgRgb.r} g=${bgRgb.g} b=${bgRgb.b}) — needs a tint`);
  else
    realm.passes.push(`bg is tinted (range=${bgRange})`);

  // 12. Selection should be inverted (fg as bg, bg as fg)
  if (s.selection_bg === s.fg && s.selection_fg === s.bg)
    realm.passes.push('Selection is properly inverted (fg↔bg)');
  else
    realm.warnings.push('Selection is not a clean fg↔bg inversion');

  return realm;
}

// ── Cross-file consistency check ──

function crossCheck(themeName, toml, luaColors, btopColors, isDark) {
  const issues = [];
  const warnings = [];
  const s = tomlToSemantic(toml);

  // colors.toml ↔ ravenwood.lua
  const luaMap = {
    bg: luaColors.bg,
    fg: luaColors.fg,
    accent: luaColors.accent,
    cursor: luaColors.cursor,
    selection_bg: luaColors.selection_bg,
    selection_fg: luaColors.selection_fg,
  };
  for (const [key, luaVal] of Object.entries(luaMap)) {
    if (luaVal && s[key] && luaVal.toLowerCase() !== s[key].toLowerCase())
      issues.push(`colors.toml ${key}=${s[key]} ≠ ravenwood.lua ${key}=${luaVal}`);
  }

  // Check ANSI: colors.toml color1-6 (dim) should match ravenwood.lua dim_* 
  const dimMap = { color1: 'dim_red', color2: 'dim_green', color3: 'dim_yellow', color4: 'dim_blue', color5: 'dim_magenta', color6: 'dim_aqua' };
  for (const [tomlKey, luaKey] of Object.entries(dimMap)) {
    if (toml[tomlKey] && luaColors[luaKey] && toml[tomlKey].toLowerCase() !== luaColors[luaKey].toLowerCase())
      issues.push(`colors.toml ${tomlKey}=${toml[tomlKey]} ≠ ravenwood.lua ${luaKey}=${luaColors[luaKey]}`);
  }

  // Check ANSI bright: colors.toml color9-14 should match ravenwood.lua full accents
  const brightMap = { color9: 'red', color10: 'green', color11: 'yellow', color12: 'blue', color13: 'magenta', color14: 'cyan' };
  for (const [tomlKey, luaKey] of Object.entries(brightMap)) {
    if (toml[tomlKey] && luaColors[luaKey] && toml[tomlKey].toLowerCase() !== luaColors[luaKey].toLowerCase())
      issues.push(`colors.toml ${tomlKey}=${toml[tomlKey]} ≠ ravenwood.lua ${luaKey}=${luaColors[luaKey]}`);
  }

  // btop: main_bg should match bg, main_fg should match fg
  if (btopColors.main_bg && s.bg && btopColors.main_bg.toLowerCase() !== s.bg.toLowerCase())
    issues.push(`btop main_bg=${btopColors.main_bg} ≠ colors.toml bg=${s.bg}`);
  if (btopColors.main_fg && s.fg && btopColors.main_fg.toLowerCase() !== s.fg.toLowerCase())
    issues.push(`btop main_fg=${btopColors.main_fg} ≠ colors.toml fg=${s.fg}`);

  // btop: btop uses FULL accent colors for its UI (not the dim ANSI dark-8).
  // Map btop fields to the full accent palette (bright ANSI slots = full variants).
  const full = {
    red: toml.color9,
    green: toml.color10,
    yellow: toml.color11,
    blue: toml.color12,
    magenta: toml.color13,
    cyan: toml.color14,
    accent: toml.accent,
  };
  const btopAccentMap = {
    hi_fg: 'red',
    selected_fg: 'accent',
    proc_misc: 'accent',
  };
  for (const [btopKey, semanticKey] of Object.entries(btopAccentMap)) {
    if (btopColors[btopKey] && full[semanticKey] && btopColors[btopKey].toLowerCase() !== full[semanticKey].toLowerCase())
      warnings.push(`btop ${btopKey}=${btopColors[btopKey]} ≠ full ${semanticKey}=${full[semanticKey]}`);
  }

  // btop: selected_bg and boxes are BACKGROUND colors (light on light themes).
  // They should match a bg palette color, NOT the ANSI black slot (which is
  // dark for text visibility on light themes).
  const btopBgFields = ['selected_bg', 'cpu_box', 'mem_box', 'net_box', 'proc_box', 'div_line'];
  const bgPaletteColors = [toml.color0, toml.color8, toml.background].filter(Boolean).map(c => c.toLowerCase());
  // For light themes, also check against the known bg ramp colors
  const knownBgColors = isDark
    ? bgPaletteColors
    : [...bgPaletteColors, '#e0dfd5', '#edece1', '#f5f4ed', '#e0dcc7', '#e6e2cc', '#f4f0d9', '#efebd4', '#f8f4e8'].map(c => c.toLowerCase());
  for (const field of btopBgFields) {
    if (btopColors[field] && !knownBgColors.includes(btopColors[field].toLowerCase()))
      warnings.push(`btop ${field}=${btopColors[field]} is not a recognized bg palette color`);
  }

  return { issues, warnings };
}

// ── Main ──

const themes = [
  { dir: 'ravenwood', name: 'Ravenwood Dark', isDark: true },
  { dir: 'ravenwood-light', name: 'Ravenwood Light', isDark: false },
];

const results = [];
const crossResults = [];

for (const t of themes) {
  const base = join(ROOT, t.dir);
  const tomlPath = join(base, 'colors.toml');
  const luaPath = join(base, 'colors', 'ravenwood.lua');
  const btopPath = join(base, 'btop.theme');

  if (!existsSync(tomlPath)) {
    console.error(`Missing ${tomlPath}`);
    continue;
  }

  const toml = parseColorsToml(tomlPath);
  const luaColors = existsSync(luaPath) ? parseLuaColors(luaPath) : {};
  const btopColors = existsSync(btopPath) ? parseBtopColors(btopPath) : {};

  const realm = analyzeTheme(t.name, toml, t.isDark, luaColors);
  results.push(realm);

  const cross = crossCheck(t.name, toml, luaColors, btopColors, t.isDark);
  crossResults.push({ name: t.name, ...cross });
}

// ── Output ──

console.log('='.repeat(80));
console.log('  RAVENWOOD OMARCHY — CONTRAST & CONSISTENCY ANALYSIS');
console.log('  Source: actual colors.toml / ravenwood.lua / btop.theme');
console.log('='.repeat(80));
console.log();

let totalIssues = 0;
let totalWarnings = 0;

for (const realm of results) {
  const mode = realm.isDark ? 'DARK' : 'LIGHT';
  console.log(`── ${realm.name.toUpperCase()} (${mode}) ──`);
  console.log(`  fg on bg:      ${realm.fgOnBg.toFixed(2)}  ${realm.fgOnBgRating}`);
  console.log(`  accent on bg:  ${realm.accentOnBg.toFixed(2)}  ${wcagRating(realm.accentOnBg)}`);
  console.log();

  if (realm.issues.length) {
    console.log(`  ❌ ISSUES (${realm.issues.length}):`);
    for (const i of realm.issues) console.log(`     ${i}`);
    console.log();
    totalIssues += realm.issues.length;
  }
  if (realm.warnings.length) {
    console.log(`  ⚠  WARNINGS (${realm.warnings.length}):`);
    for (const w of realm.warnings) console.log(`     ${w}`);
    console.log();
    totalWarnings += realm.warnings.length;
  }
  if (realm.passes.length) {
    console.log(`  ✅ PASSES (${realm.passes.length}):`);
    // Show passes in compact columns
    const passes = realm.passes;
    for (let i = 0; i < passes.length; i += 2) {
      const a = passes[i] || '';
      const b = passes[i + 1] || '';
      console.log(`     ${a}${b ? '    ' + b : ''}`);
    }
    console.log();
  }
}

// ── Cross-file consistency ──

console.log('='.repeat(80));
console.log('  CROSS-FILE CONSISTENCY (colors.toml ↔ ravenwood.lua ↔ btop.theme)');
console.log('='.repeat(80));
console.log();

let crossIssues = 0;
let crossWarnings = 0;

for (const cr of crossResults) {
  console.log(`── ${cr.name} ──`);
  if (cr.issues.length) {
    console.log(`  ❌ MISMATCHES (${cr.issues.length}):`);
    for (const i of cr.issues) console.log(`     ${i}`);
    crossIssues += cr.issues.length;
  } else {
    console.log(`  ✅ All colors match across files`);
  }
  if (cr.warnings.length) {
    console.log(`  ⚠  WARNINGS (${cr.warnings.length}):`);
    for (const w of cr.warnings) console.log(`     ${w}`);
    crossWarnings += cr.warnings.length;
  }
  console.log();
}

// ── Summary ──

console.log('='.repeat(80));
console.log(`  WCAG SUMMARY:     ${totalIssues} issues, ${totalWarnings} warnings across ${results.length} themes`);
console.log(`  CONSISTENCY:      ${crossIssues} mismatches, ${crossWarnings} warnings across ${crossResults.length} themes`);
const grandTotal = totalIssues + totalWarnings + crossIssues + crossWarnings;
if (grandTotal === 0) {
  console.log('  ✅ ALL CHECKS PASSED — themes are clean');
} else {
  console.log(`  Total findings:   ${grandTotal}`);
}
console.log('='.repeat(80));

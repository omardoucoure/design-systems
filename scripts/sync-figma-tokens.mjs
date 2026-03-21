#!/usr/bin/env node
/**
 * sync-figma-tokens.mjs
 *
 * Bidirectional sync between Swift design tokens and Figma variables.
 *
 * Usage:
 *   node scripts/sync-figma-tokens.mjs export   # Swift → JSON (for pushing to Figma via Claude)
 *   node scripts/sync-figma-tokens.mjs import   # JSON → Swift (after pulling from Figma via Claude)
 *   node scripts/sync-figma-tokens.mjs status   # Show current Swift token values
 *
 * The JSON file acts as the exchange format between Swift and Figma.
 * Claude reads/writes Figma variables via MCP and this JSON file bridges the gap.
 *
 * Workflow:
 *   1. Change a token in Swift → run `export` → ask Claude to `push` to Figma
 *   2. Change a variable in Figma → ask Claude to `pull` to JSON → run `import` to update Swift
 */

import { readFileSync, writeFileSync, existsSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";
import { createInterface } from "readline";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, "..");
const TOKEN_FILE = resolve(ROOT, "design-tokens.json");

// ─── Swift Token Parsers ───────────────────────────────────────────────────────

function parseSpacingTokens() {
  const file = readFileSync(resolve(ROOT, "ios/Sources/DesignSystem/Tokens/SpacingTokens.swift"), "utf8");
  const tokens = {};
  const regex = /public let (\w+): CGFloat = ([\d.]+)/g;
  let m;
  while ((m = regex.exec(file)) !== null) tokens[m[1]] = parseFloat(m[2]);
  return tokens;
}

function parseRadiusTokens() {
  const file = readFileSync(resolve(ROOT, "ios/Sources/DesignSystem/Tokens/RadiusTokens.swift"), "utf8");
  const roundedMatch = file.match(/static let rounded = RadiusTokens\(([\s\S]*?)\)/);
  const sharpMatch = file.match(/static let sharp = RadiusTokens\(([\s\S]*?)\)/);
  const rounded = {}, sharp = {};
  if (roundedMatch) { const r = /(\w+): ([\d.]+)/g; let m; while ((m = r.exec(roundedMatch[1])) !== null) rounded[m[1]] = parseFloat(m[2]); }
  if (sharpMatch) { const r = /(\w+): ([\d.]+)/g; let m; while ((m = r.exec(sharpMatch[1])) !== null) sharp[m[1]] = parseFloat(m[2]); }
  return { rounded, sharp };
}

function parseBorderTokens() {
  const file = readFileSync(resolve(ROOT, "ios/Sources/DesignSystem/Tokens/BorderTokens.swift"), "utf8");
  const tokens = {};
  const regex = /public let (\w+): (?:CGFloat|Double) = ([\d.]+)/g;
  let m;
  while ((m = regex.exec(file)) !== null) tokens[m[1]] = parseFloat(m[2]);
  return tokens;
}

function parseOpacityTokens() {
  const file = readFileSync(resolve(ROOT, "ios/Sources/DesignSystem/Tokens/OpacityTokens.swift"), "utf8");
  const tokens = {};
  const regex = /public let (\w+): Double = ([\d.]+)/g;
  let m;
  while ((m = regex.exec(file)) !== null) tokens[m[1]] = parseFloat(m[2]);
  return tokens;
}

function parseBrandColors() {
  const file = readFileSync(resolve(ROOT, "ios/Sources/DesignSystem/Theme/Brand.swift"), "utf8");
  const brands = {};
  const brandRegex = /case \.(\w+):\s*return BrandPrimitives\(([\s\S]*?)(?=case \.|}\s*})/g;
  let match;
  while ((match = brandRegex.exec(file)) !== null) {
    const colors = {};
    const colorRegex = /(primary\d+|secondary\d+):\s*Color\(hex:\s*"(#[0-9A-Fa-f]+)"\)/g;
    let cm;
    while ((cm = colorRegex.exec(match[2])) !== null) colors[cm[1]] = cm[2];
    const neutralRegex = /n([\d_]+):\s*Color\(hex:\s*"(#[0-9A-Fa-f]+)"\)/g;
    while ((cm = neutralRegex.exec(match[2])) !== null) colors[`neutral${cm[1].replace("_", "")}`] = cm[2];
    brands[match[1]] = colors;
  }
  return brands;
}

function parseComponentTokens() {
  const file = readFileSync(resolve(ROOT, "ios/Sources/DesignSystem/Tokens/ComponentTokens.swift"), "utf8");
  const tokens = {};
  for (const [section, prefix] of [["ButtonComponentTokens", "button"], ["TextFieldComponentTokens", "textField"]]) {
    const m = file.match(new RegExp(`static let shared = ${section}\\(([\\s\\S]*?)\\)`));
    if (m) { const r = /(\w+): ([\d.]+)/g; let cm; while ((cm = r.exec(m[1])) !== null) tokens[`${prefix}.${cm[1]}`] = parseFloat(cm[2]); }
  }
  return tokens;
}

function parseTypographyTokens() {
  const file = readFileSync(resolve(ROOT, "ios/Sources/DesignSystem/Tokens/TypographyTokens.swift"), "utf8");
  const tokens = {};
  const styleRegex = /(\w+): TypographyStyle\(size: ([\d.]+), weight: \.(\w+), lineHeight: ([\d.]+), letterSpacing: ([-\d.]+)\)/g;
  let m;
  while ((m = styleRegex.exec(file)) !== null) {
    tokens[m[1]] = { size: parseFloat(m[2]), weight: m[3], lineHeight: parseFloat(m[4]), letterSpacing: parseFloat(m[5]) };
  }
  return tokens;
}

// ─── Swift Token Writers ───────────────────────────────────────────────────────

function applyTokenToSwift(category, name, value, mode) {
  const files = {
    spacing: "ios/Sources/DesignSystem/Tokens/SpacingTokens.swift",
    border: "ios/Sources/DesignSystem/Tokens/BorderTokens.swift",
    opacity: "ios/Sources/DesignSystem/Tokens/OpacityTokens.swift",
    radius: "ios/Sources/DesignSystem/Tokens/RadiusTokens.swift",
  };
  if (!files[category]) return false;

  const filePath = resolve(ROOT, files[category]);
  let content = readFileSync(filePath, "utf8");

  if (category === "radius") {
    const section = mode === "sharp" ? "sharp" : "rounded";
    const regex = new RegExp(`(static let ${section} = RadiusTokens\\([\\s\\S]*?${name}: )([\\d.]+)`);
    content = content.replace(regex, `$1${value}`);
  } else if (category === "spacing") {
    content = content.replace(new RegExp(`(public let ${name}: CGFloat = )[\\d.]+`), `$1${value}`);
  } else if (category === "border") {
    content = content.replace(new RegExp(`(public let ${name}: (?:CGFloat|Double) = )[\\d.]+`), `$1${value}`);
  } else if (category === "opacity") {
    content = content.replace(new RegExp(`(public let ${name}: Double = )[\\d.]+`), `$1${value}`);
  }

  writeFileSync(filePath, content);
  return true;
}

// ─── Commands ──────────────────────────────────────────────────────────────────

function cmdExport() {
  console.log("📤 EXPORT: Swift → design-tokens.json\n");

  const tokens = {
    _meta: {
      generatedAt: new Date().toISOString(),
      source: "Swift design token files",
      figmaFileKey: "NzMUKWSRFEXmcH0uN5wjBC",
    },
    spacing: parseSpacingTokens(),
    radius: parseRadiusTokens(),
    border: parseBorderTokens(),
    opacity: parseOpacityTokens(),
    typography: parseTypographyTokens(),
    components: parseComponentTokens(),
    brands: parseBrandColors(),
  };

  writeFileSync(TOKEN_FILE, JSON.stringify(tokens, null, 2));

  const counts = {
    spacing: Object.keys(tokens.spacing).length,
    radius: Object.keys(tokens.radius.rounded).length,
    border: Object.keys(tokens.border).length,
    opacity: Object.keys(tokens.opacity).length,
    typography: Object.keys(tokens.typography).length,
    components: Object.keys(tokens.components).length,
    brands: Object.keys(tokens.brands).length,
    brandColors: Object.values(tokens.brands).reduce((s, b) => s + Object.keys(b).length, 0),
  };

  console.log("📊 Exported tokens:");
  for (const [k, v] of Object.entries(counts)) console.log(`   ${k}: ${v}`);
  console.log(`\n✅ Written to: ${TOKEN_FILE}`);
  console.log("\n💡 Next: ask Claude to run 'push' to sync these to Figma via MCP.");
}

function cmdImport() {
  console.log("📥 IMPORT: design-tokens.json → Swift\n");

  if (!existsSync(TOKEN_FILE)) {
    console.log("❌ No design-tokens.json found. Ask Claude to pull from Figma first.");
    process.exit(1);
  }

  const figmaTokens = JSON.parse(readFileSync(TOKEN_FILE, "utf8"));
  const swiftTokens = {
    spacing: parseSpacingTokens(),
    radius: parseRadiusTokens(),
    border: parseBorderTokens(),
    opacity: parseOpacityTokens(),
  };

  const diffs = [];

  // Compare spacing
  for (const [name, figmaVal] of Object.entries(figmaTokens.spacing || {})) {
    const swiftVal = swiftTokens.spacing[name];
    if (swiftVal !== undefined && Math.abs(swiftVal - figmaVal) > 0.001) {
      diffs.push({ category: "spacing", name, swiftValue: swiftVal, figmaValue: figmaVal });
    }
  }

  // Compare border
  for (const [name, figmaVal] of Object.entries(figmaTokens.border || {})) {
    const swiftVal = swiftTokens.border[name];
    if (swiftVal !== undefined && Math.abs(swiftVal - figmaVal) > 0.001) {
      diffs.push({ category: "border", name, swiftValue: swiftVal, figmaValue: figmaVal });
    }
  }

  // Compare opacity
  for (const [name, figmaVal] of Object.entries(figmaTokens.opacity || {})) {
    const swiftVal = swiftTokens.opacity[name];
    if (swiftVal !== undefined && Math.abs(swiftVal - figmaVal) > 0.001) {
      diffs.push({ category: "opacity", name, swiftValue: swiftVal, figmaValue: figmaVal });
    }
  }

  // Compare radius
  for (const mode of ["rounded", "sharp"]) {
    for (const [name, figmaVal] of Object.entries(figmaTokens.radius?.[mode] || {})) {
      const swiftVal = swiftTokens.radius[mode]?.[name];
      if (swiftVal !== undefined && Math.abs(swiftVal - figmaVal) > 0.001) {
        diffs.push({ category: "radius", name, mode, swiftValue: swiftVal, figmaValue: figmaVal });
      }
    }
  }

  if (diffs.length === 0) {
    console.log("✅ Everything is in sync! No differences.\n");
    return;
  }

  console.log(`Found ${diffs.length} difference(s):\n`);
  for (let i = 0; i < diffs.length; i++) {
    const d = diffs[i];
    const modeLabel = d.mode ? ` [${d.mode}]` : "";
    console.log(`  ${i + 1}. ${d.category}/${d.name}${modeLabel}: Swift=${d.swiftValue} → Figma=${d.figmaValue}`);
  }

  const rl = createInterface({ input: process.stdin, output: process.stdout });
  rl.question(`\nApply ${diffs.length} change(s) to Swift code? (y/n): `, (answer) => {
    rl.close();
    if (answer.trim().toLowerCase() === "y") {
      let applied = 0;
      for (const diff of diffs) {
        if (applyTokenToSwift(diff.category, diff.name, diff.figmaValue, diff.mode)) {
          console.log(`  ✅ ${diff.category}/${diff.name}: ${diff.swiftValue} → ${diff.figmaValue}`);
          applied++;
        }
      }
      console.log(`\n📊 Applied ${applied}/${diffs.length} changes to Swift.`);
      console.log("💡 Build to verify the changes.");
    } else {
      console.log("❌ Cancelled.");
    }
  });
}

function cmdStatus() {
  console.log("📊 Current Swift token values:\n");
  const spacing = parseSpacingTokens();
  const radius = parseRadiusTokens();
  const border = parseBorderTokens();
  const opacity = parseOpacityTokens();
  const typography = parseTypographyTokens();
  const components = parseComponentTokens();
  const brands = parseBrandColors();

  console.log("Spacing:", spacing);
  console.log("\nRadius (Rounded):", radius.rounded);
  console.log("Radius (Sharp):", radius.sharp);
  console.log("\nBorder:", border);
  console.log("Opacity:", opacity);
  console.log("\nTypography:", Object.fromEntries(Object.entries(typography).map(([k, v]) => [k, `${v.size}px ${v.weight}`])));
  console.log("\nComponents:", components);
  console.log(`\nBrands: ${Object.keys(brands).join(", ")} (${Object.values(brands).reduce((s, b) => s + Object.keys(b).length, 0)} colors total)`);

  if (existsSync(TOKEN_FILE)) {
    const stat = readFileSync(TOKEN_FILE, "utf8");
    const meta = JSON.parse(stat)._meta;
    console.log(`\n📄 Last export: ${meta?.generatedAt || "unknown"}`);
  } else {
    console.log("\n📄 No design-tokens.json yet. Run 'export' to create one.");
  }
}

// ─── Main ──────────────────────────────────────────────────────────────────────

const command = process.argv[2] || "status";

switch (command) {
  case "export": cmdExport(); break;
  case "import": cmdImport(); break;
  case "status": cmdStatus(); break;
  default:
    console.log("Usage: sync-figma-tokens.mjs <export|import|status>\n");
    console.log("  export   Swift → design-tokens.json (then Claude pushes to Figma)");
    console.log("  import   design-tokens.json → Swift (after Claude pulls from Figma)");
    console.log("  status   Show current Swift token values");
    console.log("\nWorkflow:");
    console.log("  Changed Swift?  → export → ask Claude: 'push tokens to Figma'");
    console.log("  Changed Figma?  → ask Claude: 'pull tokens from Figma' → import");
    process.exit(1);
}

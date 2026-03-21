#!/usr/bin/env node
/**
 * import-figma-icons.mjs
 *
 * Imports all 1364 DS icons into the Figma design system file.
 * Connects directly to the Figma Console MCP WebSocket server.
 *
 * Prerequisites:
 *   - Figma Desktop open with the target file
 *   - Figma Desktop Bridge plugin running
 *   - MCP server running (auto-started by Claude, or `npx figma-console-mcp@latest`)
 *
 * Usage:
 *   node scripts/import-figma-icons.mjs
 *   node scripts/import-figma-icons.mjs --start=100   # Resume from icon 100
 *   node scripts/import-figma-icons.mjs --batch=5     # 5 icons per batch (default: 8)
 */

import { readFileSync, readdirSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";
import WebSocket from "ws";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, "..");
const ICONS_DIR = resolve(ROOT, "ios/Sources/DesignSystem/Resources/Icons.xcassets");
const PORT = 9223;
const COLS = 20;
const CELL_W = 88;
const CELL_H = 56;

// Parse args
const args = process.argv.slice(2);
const startIdx = parseInt(args.find(a => a.startsWith("--start="))?.split("=")[1] || "0");
const batchSize = parseInt(args.find(a => a.startsWith("--batch="))?.split("=")[1] || "8");

// ─── Load all icon SVGs ────────────────────────────────────────────────────────

function loadIcons() {
  const dirs = readdirSync(ICONS_DIR)
    .filter(d => d.endsWith(".imageset"))
    .sort();

  const icons = [];
  for (const dir of dirs) {
    const name = dir.replace(".imageset", "");
    const svgPath = resolve(ICONS_DIR, dir, `${name}.svg`);
    try {
      const svg = readFileSync(svgPath, "utf8").replace(/\n/g, " ").trim();
      icons.push({ name: name.replace("icon_", ""), svg });
    } catch (e) {
      // skip missing SVGs
    }
  }
  return icons;
}

// ─── WebSocket connection ──────────────────────────────────────────────────────

let ws;
let requestId = 0;
const pending = new Map();

function connect() {
  return new Promise((resolve, reject) => {
    ws = new WebSocket(`ws://localhost:${PORT}`);
    ws.on("open", () => {
      console.log(`✅ Connected to MCP server on port ${PORT}`);
    });
    ws.on("message", (data) => {
      const msg = JSON.parse(data.toString());
      if (msg.type === "SERVER_HELLO") {
        resolve();
        return;
      }
      // Match response to pending request
      if (msg.id && pending.has(msg.id)) {
        const { resolve: res, reject: rej } = pending.get(msg.id);
        pending.delete(msg.id);
        if (msg.error) rej(new Error(msg.error));
        else res(msg.result || msg);
      }
    });
    ws.on("error", (err) => reject(err));
    ws.on("close", () => {
      console.log("❌ WebSocket disconnected");
    });
  });
}

function execFigma(code, timeout = 25000) {
  return new Promise((resolve, reject) => {
    const id = `import_${++requestId}_${Date.now()}`;
    const timer = setTimeout(() => {
      pending.delete(id);
      reject(new Error("Timeout"));
    }, timeout + 5000);

    pending.set(id, {
      resolve: (result) => { clearTimeout(timer); resolve(result); },
      reject: (err) => { clearTimeout(timer); reject(err); },
    });

    ws.send(JSON.stringify({
      id,
      method: "EXECUTE_CODE",
      params: { code, timeout },
    }));
  });
}

// ─── Import logic ──────────────────────────────────────────────────────────────

async function setupPage() {
  console.log("📄 Setting up Icons page...");
  await execFigma(`
    await figma.loadAllPagesAsync();
    let p = figma.root.children.find(p => p.name === 'Icons');
    if (!p) { p = figma.createPage(); p.name = 'Icons'; }
    await figma.setCurrentPageAsync(p);
    let c = p.findOne(n => n.name === 'Icon Library');
    if (!c) {
      await figma.loadFontAsync({ family: "DM Sans", style: "Bold" });
      c = figma.createFrame();
      c.name = 'Icon Library';
      c.fills = [{ type: 'SOLID', color: { r: 1, g: 1, b: 1 } }];
      c.cornerRadius = 24;
      c.x = 0; c.y = 0;
      c.resize(1800, 5000);
      const t = figma.createText();
      t.fontName = { family: "DM Sans", style: "Bold" };
      t.characters = '1364 Icons — DSIcon Enum';
      t.fontSize = 28;
      t.fills = [{ type: 'SOLID', color: { r: 0.16, g: 0.16, b: 0.15 } }];
      t.x = 48; t.y = 48;
      c.appendChild(t);
      p.appendChild(c);
    }
    return { success: true };
  `);
}

async function importBatch(icons, globalIdx) {
  // Build JS code for this batch
  const lines = [
    `const p = figma.root.children.find(p => p.name === 'Icons');`,
    `await figma.setCurrentPageAsync(p);`,
    `const c = p.findOne(n => n.name === 'Icon Library');`,
    `const r = [];`,
  ];

  for (let i = 0; i < icons.length; i++) {
    const idx = globalIdx + i;
    const col = idx % COLS;
    const row = Math.floor(idx / COLS);
    const x = col * CELL_W + 48;
    const y = row * CELL_H + 100;
    const svg = icons[i].svg.replace(/'/g, "\\'");
    const name = icons[i].name;

    lines.push(
      `try{const n=figma.createNodeFromSvg('${svg}');` +
      `n.name='${name}';n.resize(24,24);` +
      `n.x=${x};n.y=${y};` +
      `c.appendChild(n);r.push('${name}');}` +
      `catch(e){r.push('${name}:E');}`
    );
  }

  lines.push(`return{created:r,count:r.length};`);
  const code = lines.join("\n");

  const result = await execFigma(code, 25000);
  return result;
}

// ─── Main ──────────────────────────────────────────────────────────────────────

async function main() {
  const icons = loadIcons();
  console.log(`📦 Loaded ${icons.length} icons from ${ICONS_DIR}`);
  console.log(`🔧 Batch size: ${batchSize}, starting from: ${startIdx}`);

  await connect();
  await setupPage();

  const toImport = icons.slice(startIdx);
  const totalBatches = Math.ceil(toImport.length / batchSize);
  let imported = 0;
  let errors = 0;

  for (let b = 0; b < totalBatches; b++) {
    const start = b * batchSize;
    const end = Math.min(start + batchSize, toImport.length);
    const batch = toImport.slice(start, end);
    const globalIdx = startIdx + start;

    process.stdout.write(
      `\r  Batch ${b + 1}/${totalBatches} (icons ${globalIdx + 1}-${globalIdx + batch.length}/${icons.length}) `
    );

    try {
      const result = await importBatch(batch, globalIdx);
      const batchErrors = (result?.created || []).filter(n => n.endsWith(":E")).length;
      imported += batch.length - batchErrors;
      errors += batchErrors;
      process.stdout.write(`✅ ${batch.length - batchErrors} ok`);
    } catch (e) {
      process.stdout.write(`❌ ${e.message}`);
      errors += batch.length;
      // Wait and retry
      await new Promise(r => setTimeout(r, 2000));
    }

    // Small delay between batches to not overwhelm
    await new Promise(r => setTimeout(r, 500));
  }

  console.log(`\n\n📊 Done: ${imported} imported, ${errors} errors`);
  ws.close();
}

main().catch(err => {
  console.error("❌", err.message);
  process.exit(1);
});

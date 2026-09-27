import { readFileSync, writeFileSync } from "node:fs";
const page = readFileSync("index.html", "utf8");
const parts = ["a", "b"].map(name => readFileSync(`parts/${name}.html`, "utf8").trim()).filter(Boolean).join("\n\n");
writeFileSync("index.html", page.replace(/<!-- parts -->[\s\S]*<!-- \/parts -->/, `<!-- parts -->\n${parts}\n<!-- /parts -->`));

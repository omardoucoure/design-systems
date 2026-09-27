import { readFileSync, writeFileSync } from "node:fs";
import { jdm } from "./jdm.mjs";
const src = readFileSync(new URL("a.html", import.meta.url), "utf8");
const pd = readFileSync(new URL("../app/pd.html", import.meta.url), "utf8").trim();
writeFileSync(new URL("../parts/a.html", import.meta.url), src.replace("@@PD@@", () => pd).replaceAll("@@JDM@@", () => jdm));

import { readFileSync, writeFileSync } from "node:fs";
import { jdm } from "./jdm.mjs";
const deck = new URL("..", import.meta.url).pathname;
const here = new URL(".", import.meta.url).pathname;
const pa = readFileSync(`${deck}/app/pa.html`, "utf8").trim();

const badge = attrs => `<span class="da-live" ${attrs}><span class="da-live__text">EN DIRECT</span><svg class="da-live__icon" viewBox="0 0 24 16"><circle cx="12" cy="8" r="2"/><path d="M8 4.5a5 5 0 0 0 0 7M16 4.5a5 5 0 0 1 0 7M5 1.5a9.5 9.5 0 0 0 0 13M19 1.5a9.5 9.5 0 0 1 0 13"/></svg></span>`;

const phone = (overlay, insp) => `<div class="da-phone db-phone"><div class="da-jdm da-jdm--db">
  <div class="da-jdm__pts">
@@JDM@@
${overlay}
  </div>
  <span class="db-hero"></span>
  <span class="da-jdm__spot db-insp ${insp}"><span class="db-insp__tag">Badge · 12 px · radius 4</span></span>
</div></div>`;

const phone9 = phone("", `" data-anim="state" data-step="2" data-delay="700`);
const phone10 = phone(badge(`data-anim="state" data-step="3"`), "db-insp--on");

const out = readFileSync(`${here}/b.html`, "utf8")
  .replaceAll("@@PA@@", pa)
  .replace("@@PHONE9@@", phone9)
  .replace("@@PHONE10@@", phone10)
  .replaceAll("@@JDM@@", () => jdm);
writeFileSync(`${deck}/parts/b.html`, out);

import { existsSync, readFileSync } from "node:fs";
const file = new URL("../app/jdm.html", import.meta.url);
export const jdm = existsSync(file) ? readFileSync(file, "utf8").trim() : `<img class="da-jdm__img" src="app/jdm/accueil.png" alt="">`;

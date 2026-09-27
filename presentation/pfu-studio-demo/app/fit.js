(function () {
  const WEIGHTS = [400, 500, 600, 700];
  const FAMILIES = ["Barlow Condensed", "Oswald", "Roboto Condensed"];
  const INK_RATIO = 1;
  const SHAPE_WEIGHT = 0.25;
  const canvas = document.createElement("canvas");
  const ctx = canvas.getContext("2d", { willReadFrequently: true });

  function family(el) {
    return getComputedStyle(el).fontFamily;
  }

  function coverage(text, size, weight, fam, w, h) {
    canvas.width = Math.ceil(w * 2);
    canvas.height = Math.ceil(h * 2);
    ctx.scale(2, 2);
    ctx.font = `${weight} ${size}px ${fam}`;
    ctx.textBaseline = "middle";
    ctx.fillText(text, 0, h / 2);
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    const data = ctx.getImageData(0, 0, canvas.width, canvas.height).data;
    let inked = 0;
    for (let i = 3; i < data.length; i += 4) if (data[i] > 127) inked++;
    return inked / (canvas.width * canvas.height);
  }

  function inkHeight(text, size, weight, fam) {
    ctx.font = `${weight} ${size}px ${fam}`;
    const m = ctx.measureText(text);
    return m.actualBoundingBoxAscent + m.actualBoundingBoxDescent;
  }

  function candidates(el) {
    const base = family(el);
    return [base].concat(FAMILIES.filter(f => document.fonts.check(`700 20px "${f}"`)).map(f => `"${f}", ${base}`));
  }

  function fit(el) {
    const w = +el.dataset.w, h = +el.dataset.h;
    const target = parseFloat(el.dataset.cov || "0");
    let best = null;
    for (const fam of candidates(el)) {
      for (const weight of WEIGHTS) {
        ctx.font = `${weight} 100px ${fam}`;
        const size = Math.min((w / ctx.measureText(el.textContent).width) * 100, h * 1.6);
        const shape = Math.abs(inkHeight(el.textContent, size, weight, fam) / h - INK_RATIO);
        const score = shape * SHAPE_WEIGHT + Math.abs(coverage(el.textContent, size, weight, fam, w, h) - target);
        if (!best || score < best.score) best = { fam, weight, size, score };
      }
    }
    el.style.fontFamily = best.fam;
    el.style.fontSize = `${best.size.toFixed(1)}px`;
    el.style.fontWeight = best.weight;
  }

  function scale() {
    document.querySelectorAll("[data-fit-root]").forEach(root => {
      const target = root.firstElementChild;
      const s = Math.min(root.clientWidth / target.offsetWidth, 1);
      target.style.transform = `scale(${s})`;
      root.style.height = `${target.offsetHeight * s}px`;
    });
  }

  Promise.all(FAMILIES.flatMap(f => WEIGHTS.map(w => document.fonts.load(`${w} 20px "${f}"`).catch(() => [])))).then(() => document.fonts.ready).then(() => {
    document.querySelectorAll("[data-cov]").forEach(fit);
    scale();
  });
  addEventListener("resize", scale);
})();

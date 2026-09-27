(function (root) {
  const ARC_GAP = 0.4;
  const ARC_BULGE = 0.55;
  const stepOf = element => Number(element.dataset.step) || 0;

  function seeded(seed) {
    let state = seed;
    return () => {
      state = (state * 16807) % 2147483647;
      return (state - 1) / 2147483646;
    };
  }

  function between(rand, low, high) {
    return low + Math.floor(rand() * (high - low + 1));
  }

  function makeLine(indent, parts) {
    const line = document.createElement("div");
    line.className = "cd-line" + (indent ? " cd-in" + indent : "");
    parts.forEach(([kind, width]) => {
      const bar = document.createElement("i");
      bar.className = "cd-bar cd-w" + width + (kind ? " cd-bar--" + kind : "");
      line.appendChild(bar);
    });
    return line;
  }

  function jsonLine(rand, state) {
    const roll = rand();
    if (roll < 0.18 && state.depth < 5) {
      state.depth += 1;
      return makeLine(state.depth - 1, [["key", between(rand, 2, 4)], ["dim", 1]]);
    }
    if (roll < 0.34 && state.depth > 1) {
      state.depth -= 1;
      return makeLine(state.depth, [["dim", 1]]);
    }
    return makeLine(state.depth, [["key", between(rand, 2, 4)], [rand() < 0.75 ? "str" : "num", between(rand, 2, 8)]]);
  }

  function codeLine(rand, state) {
    state.depth = Math.max(0, Math.min(3, state.depth + between(rand, -1, 1)));
    const kinds = ["kw", "fn", "", "str", "", "num"];
    const parts = [[rand() < 0.5 ? "kw" : "", between(rand, 1, 3)]];
    const extra = between(rand, 0, 3);
    for (let index = 0; index < extra; index += 1) parts.push([kinds[between(rand, 0, kinds.length - 1)], between(rand, 1, 4)]);
    return makeLine(state.depth, parts);
  }

  function generate(code) {
    const rand = seeded(Number(code.dataset.cdSeed) || 7);
    const count = Number(code.dataset.cdLines) || 20;
    const build = code.dataset.cdGreek === "json" ? jsonLine : codeLine;
    const state = { depth: 1 };
    const fragment = document.createDocumentFragment();
    for (let index = 0; index < count; index += 1) fragment.appendChild(build(rand, state));
    code.insertBefore(fragment, code.firstChild);
  }

  function loopScroll(track) {
    Array.from(track.children).forEach(child => {
      const copy = child.cloneNode(true);
      copy.setAttribute("aria-hidden", "true");
      track.appendChild(copy);
    });
  }

  function lineEnd(line) {
    const last = Array.from(line.children).filter(child => !child.classList.contains("cd-line__end")).pop();
    const x = last ? last.offsetLeft + last.offsetWidth : line.offsetWidth / 2;
    return { x: line.offsetLeft + x, y: line.offsetTop + line.offsetHeight / 2 };
  }

  function drawArc(path, code) {
    const lines = code.querySelectorAll(".cd-line");
    const from = lines[Number(path.dataset.fromLine) - 1];
    const to = lines[Number(path.dataset.toLine) - 1];
    if (!from || !to) return;
    const gap = parseFloat(getComputedStyle(code).fontSize) * ARC_GAP;
    const a = lineEnd(from);
    const b = lineEnd(to);
    const bulge = Math.max(a.x, b.x) + gap + Math.abs(b.y - a.y) * ARC_BULGE;
    const r = value => Math.round(value * 10) / 10;
    path.setAttribute("d", `M${r(a.x + gap)} ${r(a.y)} C${r(bulge)} ${r(a.y)} ${r(bulge)} ${r(b.y)} ${r(b.x + gap)} ${r(b.y)}`);
    path.style.setProperty("--len", path.getTotalLength() + "px");
  }

  function drawArcs() {
    document.querySelectorAll(".cd-arc[data-from-line]").forEach(path => drawArc(path, path.closest(".cd-code")));
  }

  function latestShown(container, selector, except, extra) {
    const shown = Array.from(container.querySelectorAll(selector))
      .filter(element => element !== except && (element === extra || element.classList.contains("is-shown")));
    return shown.sort((a, b) => stepOf(a) - stepOf(b)).pop();
  }

  function aimMarker(code, target) {
    const marker = code.querySelector(".cd-marker");
    if (!marker) return;
    if (!target) {
      marker.classList.remove("is-on");
      return;
    }
    const y = target.offsetTop + "px";
    if (!marker.classList.contains("is-on")) {
      marker.style.transition = "none";
      marker.style.setProperty("--cd-y", y);
      void marker.offsetWidth;
      marker.style.transition = "";
      marker.classList.add("is-on");
      return;
    }
    marker.style.setProperty("--cd-y", y);
  }

  const walk = {
    play: element => {
      const code = element.closest(".cd-code");
      aimMarker(code, latestShown(code, '[data-anim="cd-walk"]', null, element));
    },
    reset: element => {
      const code = element.closest(".cd-code");
      aimMarker(code, latestShown(code, '[data-anim="cd-walk"]', element));
    }
  };

  function aimJump(track, target) {
    const view = track.parentElement;
    const max = Math.max(0, track.offsetHeight - view.clientHeight);
    const context = target ? parseFloat(getComputedStyle(target).lineHeight) : 0;
    const y = target ? Math.min(max, Math.max(0, target.offsetTop - context)) : 0;
    track.style.setProperty("--cd-jump-y", -y + "px");
  }

  const jump = {
    play: element => {
      const track = element.closest(".cd-jump__track");
      aimJump(track, latestShown(track, '[data-anim="cd-jump"]', null, element));
    },
    reset: element => {
      const track = element.closest(".cd-jump__track");
      aimJump(track, latestShown(track, '[data-anim="cd-jump"]', element));
    }
  };

  document.querySelectorAll(".cd-code[data-cd-greek]").forEach(generate);
  document.querySelectorAll(".cd-scroll__track").forEach(loopScroll);
  document.querySelectorAll(".cd-scan").forEach(scan => {
    Array.from(scan.children).forEach((child, index) => child.style.setProperty("--i", String(index)));
  });
  drawArcs();
  if (document.fonts) document.fonts.ready.then(drawArcs);
  root.addEventListener("resize", drawArcs);
  root.DeckEffects.register("cd-walk", walk);
  root.DeckEffects.register("cd-jump", jump);
})(window);

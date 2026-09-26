# Motion Deck Kit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reusable click-driven HTML deck kit built on the HaHo web design system, plus the PFU Studio talk (French) built with it.

**Architecture:** Kit lives in `design-system-web/deck/` (separate git repo, ignored by the parent repo): `deck.css` (stage, scenes, reveal animations, layout helpers), `deck-state.js` (pure navigation math, node-tested), `effects.js` (count, type, draw, bubble, check), `deck.js` (DOM wiring, keys, hash, scaling). Talks live in `design-systems/presentation/<talk>/` and link the kit by relative path. Classic scripts only (ES modules fail on `file://`).

**Tech Stack:** HTML, CSS custom properties, vanilla JS (classic scripts), `node --test` for pure logic, Chrome for visual verification.

## Global Constraints

- Every color, spacing, radius, font, border, duration comes from `tokens.css` or a `--deck-*` token in `deck.css :root`; no raw hex/rgb in kit or talk files.
- UI uses DS classes from `components.css` (`card`, `btn`, `tag`, `list`, `list-item`, `avatar`, `checkbox`, `progress-ring`, `device`, `statusbar`, `home-indicator`, `t-*`).
- Light style: `<body class="deck" data-brand="coralCamo" data-style="lightRounded">`, page background `--surface-page` (`#FAFAF9`).
- Stage 1280×720 logical, scaled to viewport.
- No source file over 400 lines. No code comments (HTML, CSS, JS).
- Works offline from disk; no CDN.
- `prefers-reduced-motion: reduce` → instant reveals.
- Commits: English, sentence case, end with `Claude-Session: https://claude.ai/code/session_01RE2LP7iTw8QSDuT6dJmoRe`. Never push.
- Two repos: `design-system-web/` (Tasks 1–4) and `design-systems/` (Tasks 5–7).

## File Map

| File | Repo | Responsibility |
|---|---|---|
| `tokens.css` | design-system-web | + motion tokens, + `--surface-highlight` |
| `deck/deck.css` | design-system-web | stage, scenes, camera, reveals, layout helpers, window, device, bubble |
| `deck/deck-state.js` | design-system-web | `next`, `prev`, `parseHash`, `formatHash` |
| `deck/tests/deck-state.test.js` | design-system-web | node tests for state |
| `deck/effects.js` | design-system-web | `DeckEffects.play/reset/prepare` |
| `deck/deck.js` | design-system-web | DOM wiring |
| `deck/template/index.html` | design-system-web | starter talk showing every API feature |
| `README.md`, `package.json` | design-system-web | docs + ship `deck/` |
| `presentation/pfu-studio/index.html` | design-systems | 10 scenes |
| `deck/patterns.css` | design-system-web | reusable scene patterns (hub, orbit, metrics, gauge, versus, roadmap) |
| `deck/PATTERNS.md` | design-system-web | scene pattern catalog with snippets (Task 8) |
| `~/.claude/skills/motion-deck/SKILL.md` | user skills | story prompt → talk folder (Task 8) |

---

### Task 1: Motion and highlight tokens

**Files:**
- Modify: `design-system-web/tokens.css` (`:root` block after shadows; `[data-style^="light"]`; `[data-style^="dark"]`)

**Interfaces:**
- Produces: `--motion-dur-fast`, `--motion-dur-base`, `--motion-dur-slow`, `--motion-dur-scene`, `--motion-dur-count`, `--motion-dur-typing`, `--motion-type-char`, `--motion-ease-out`, `--motion-ease-spring`, `--motion-stagger`, `--surface-highlight`.

- [ ] **Step 1: Check tokens absent**

Run: `cd design-system-web && grep -c -- "--motion-\|--surface-highlight" tokens.css`
Expected: `0`

- [ ] **Step 2: Add motion tokens** — in `:root`, after `--shadow-floating: …;` line, insert:

```css

  --motion-dur-fast: 200ms;
  --motion-dur-base: 400ms;
  --motion-dur-slow: 700ms;
  --motion-dur-scene: 900ms;
  --motion-dur-count: 1600ms;
  --motion-dur-typing: 1200ms;
  --motion-type-char: 28ms;
  --motion-ease-out: cubic-bezier(0.22, 1, 0.36, 1);
  --motion-ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
  --motion-stagger: 80ms;
```

- [ ] **Step 3: Add highlight surface** — in `[data-style^="light"]` after `--surface-overlay:     var(--n-0);` add `  --surface-highlight:   var(--s-40);`; in `[data-style^="dark"]` after `--surface-overlay:     var(--n-9);` add `  --surface-highlight:   var(--s-100);`

- [ ] **Step 4: Verify**

Run: `grep -c -- "--motion-" tokens.css; grep -c -- "--surface-highlight" tokens.css`
Expected: `10` then `2`

- [ ] **Step 5: Commit**

```bash
git add tokens.css
git commit -m "Add motion and highlight tokens"
```

---

### Task 2: Navigation state (TDD)

**Files:**
- Create: `design-system-web/deck/deck-state.js`
- Test: `design-system-web/deck/tests/deck-state.test.js`
- Modify: `design-system-web/package.json` (add `scripts.test`)

**Interfaces:**
- Produces (browser: `window.DeckState`; node: `module.exports`):
  - `next(counts: number[], pos: {scene, step}) → {scene, step}`
  - `prev(counts, pos) → {scene, step}`
  - `parseHash(counts, hash: string) → {scene, step}` (hash `#<scene 1-based>.<step>`)
  - `formatHash(pos) → string`
  - `counts[i]` = highest `data-step` in scene `i` (0 if none).

- [ ] **Step 1: Write failing tests** — `deck/tests/deck-state.test.js`:

```js
const test = require("node:test");
const assert = require("node:assert/strict");
const { next, prev, parseHash, formatHash } = require("../deck-state.js");

const counts = [0, 2, 1];

test("next reveals the next step in the scene", () => {
  assert.deepEqual(next(counts, { scene: 1, step: 0 }), { scene: 1, step: 1 });
});

test("next moves to the next scene after the last step", () => {
  assert.deepEqual(next(counts, { scene: 1, step: 2 }), { scene: 2, step: 0 });
});

test("next stays on the last step of the last scene", () => {
  assert.deepEqual(next(counts, { scene: 2, step: 1 }), { scene: 2, step: 1 });
});

test("prev hides the last revealed step", () => {
  assert.deepEqual(prev(counts, { scene: 1, step: 2 }), { scene: 1, step: 1 });
});

test("prev returns to the previous scene fully revealed", () => {
  assert.deepEqual(prev(counts, { scene: 2, step: 0 }), { scene: 1, step: 2 });
});

test("prev stays at the start of the first scene", () => {
  assert.deepEqual(prev(counts, { scene: 0, step: 0 }), { scene: 0, step: 0 });
});

test("parseHash reads scene and step", () => {
  assert.deepEqual(parseHash(counts, "#2.1"), { scene: 1, step: 1 });
});

test("parseHash clamps step to the scene count", () => {
  assert.deepEqual(parseHash(counts, "#2.9"), { scene: 1, step: 2 });
});

test("parseHash defaults step to zero", () => {
  assert.deepEqual(parseHash(counts, "#3"), { scene: 2, step: 0 });
});

test("parseHash falls back to the start on invalid input", () => {
  assert.deepEqual(parseHash(counts, "#9.0"), { scene: 0, step: 0 });
  assert.deepEqual(parseHash(counts, ""), { scene: 0, step: 0 });
  assert.deepEqual(parseHash(counts, "#abc"), { scene: 0, step: 0 });
});

test("formatHash is one-based on scenes", () => {
  assert.equal(formatHash({ scene: 1, step: 2 }), "#2.2");
});
```

- [ ] **Step 2: Run, verify fail**

Run: `cd design-system-web && node --test deck/tests/deck-state.test.js`
Expected: FAIL, `Cannot find module '../deck-state.js'`

- [ ] **Step 3: Implement** — `deck/deck-state.js`:

```js
(function (root) {
  function next(counts, pos) {
    if (pos.step < counts[pos.scene]) return { scene: pos.scene, step: pos.step + 1 };
    if (pos.scene < counts.length - 1) return { scene: pos.scene + 1, step: 0 };
    return pos;
  }

  function prev(counts, pos) {
    if (pos.step > 0) return { scene: pos.scene, step: pos.step - 1 };
    if (pos.scene > 0) return { scene: pos.scene - 1, step: counts[pos.scene - 1] };
    return pos;
  }

  function parseHash(counts, hash) {
    const match = /^#?(\d+)(?:\.(\d+))?$/.exec(hash || "");
    if (!match) return { scene: 0, step: 0 };
    const scene = Number(match[1]) - 1;
    if (scene < 0 || scene >= counts.length) return { scene: 0, step: 0 };
    return { scene, step: Math.min(Number(match[2] || 0), counts[scene]) };
  }

  function formatHash(pos) {
    return "#" + (pos.scene + 1) + "." + pos.step;
  }

  const api = { next, prev, parseHash, formatHash };
  if (typeof module !== "undefined" && module.exports) module.exports = api;
  else root.DeckState = api;
})(this);
```

- [ ] **Step 4: Run, verify pass**

Run: `node --test deck/tests/deck-state.test.js`
Expected: `# pass 11`, `# fail 0`

- [ ] **Step 5: Add test script** — in `package.json` after `"main": "index.js",` add:

```json
  "scripts": {
    "test": "node --test deck/tests/deck-state.test.js"
  },
```

Run: `npm test` → `# pass 11`

- [ ] **Step 6: Commit**

```bash
git add deck/deck-state.js deck/tests/deck-state.test.js package.json
git commit -m "Add deck navigation state with tests"
```

---

### Task 3: Deck engine (CSS, effects, DOM) + starter template

**Files:**
- Create: `design-system-web/deck/deck.css`, `deck/effects.js`, `deck/deck.js`, `deck/template/index.html`

**Interfaces:**
- Consumes: `DeckState` (Task 2), motion tokens + `--surface-highlight` (Task 1).
- Produces for talks:
  - Page skeleton: `body.deck` › `main.deck__stage` › `section.scene`* + `div.deck__progress > div.deck__progress-bar`; scripts in order `deck-state.js`, `effects.js`, `deck.js`.
  - Attributes: `data-step="n"`, `data-anim="rise|fade|pop|slide-left|slide-right|grow|draw|count|type|bubble|check"`, `data-stagger`, `data-camera="fade|zoom|pan-left|pan-up"`, `data-next`, `data-count-from`, `data-count-to`, `data-draw-to`, `data-done`.
  - Classes: `mark.hl` (sweeps when an ancestor is `.is-shown`), `.deck-row`, `.deck-grow`, `.deck-stack`, `.deck-center`, `.deck-text-center`, `.deck-kicker`, `.deck-lead`, `.deck-window(__bar|__dot|__title|__body)`, `.deck-screens`, `.deck-screen`, `.deck-skel(--title|--short|--mid|--block)`, `.deck-device`, `.deck-bubble`, `.deck-bubble__message`, `.deck-typing`, `.deck-ring`.
  - Screens are mockups built from DS classes + `.deck-skel` bars inside `.deck-screen` panels; no images. Stacked panels in `.deck-screens` switch via `data-step` + `data-anim="fade"`.
  - `window.DeckEffects = { play(el), reset(el), prepare(el) }`.

- [ ] **Step 1: Write `deck/deck.css`**

```css
:root {
  --deck-width: 1280px;
  --deck-height: 720px;
  --deck-zoom-from: 0.92;
  --deck-zoom-past: 1.08;
  --deck-pop-from: 0.6;
  --deck-device-scale: 0.6;
  --deck-ring-size: 160px;
}

.deck {
  margin: 0;
  height: 100vh;
  overflow: hidden;
  background: var(--surface-page);
  color: var(--text-primary);
  font-family: var(--font-sans);
  -webkit-font-smoothing: antialiased;
}
.deck *, .deck *::before, .deck *::after { box-sizing: border-box; }

.deck__stage {
  position: absolute;
  top: 50%;
  left: 50%;
  width: var(--deck-width);
  height: var(--deck-height);
  overflow: hidden;
  transform: translate(-50%, -50%) scale(var(--deck-scale, 1));
}

.scene {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: var(--space-lg);
  padding: var(--space-xxxxl);
  opacity: 0;
  visibility: hidden;
  pointer-events: none;
  transition:
    opacity var(--motion-dur-scene) var(--motion-ease-out),
    transform var(--motion-dur-scene) var(--motion-ease-out),
    visibility 0s linear var(--motion-dur-scene);
}
.scene[data-camera="zoom"] { transform: scale(var(--deck-zoom-from)); }
.scene[data-camera="zoom"].is-past { transform: scale(var(--deck-zoom-past)); }
.scene[data-camera="pan-left"] { transform: translateX(var(--space-xxxxl)); }
.scene[data-camera="pan-left"].is-past { transform: translateX(calc(-1 * var(--space-xxxxl))); }
.scene[data-camera="pan-up"] { transform: translateY(var(--space-xxxxl)); }
.scene[data-camera="pan-up"].is-past { transform: translateY(calc(-1 * var(--space-xxxxl))); }
.scene.is-active {
  opacity: 1;
  visibility: visible;
  pointer-events: auto;
  transform: none;
  transition-delay: 0s;
}

:is([data-anim], [data-step]) {
  transition:
    opacity var(--motion-dur-slow) var(--motion-ease-out),
    transform var(--motion-dur-slow) var(--motion-ease-out);
}
:is([data-anim], [data-step]):not([data-stagger], [data-anim="draw"], [data-anim="grow"], .is-shown) {
  opacity: 0;
  pointer-events: none;
}
:is([data-anim="rise"], [data-anim="check"]):not(.is-shown) { transform: translateY(var(--space-xl)); }
[data-anim="slide-left"]:not(.is-shown) { transform: translateX(var(--space-xxxxl)); }
[data-anim="slide-right"]:not(.is-shown) { transform: translateX(calc(-1 * var(--space-xxxxl))); }
:is([data-anim="pop"], [data-anim="bubble"]) { transition-timing-function: var(--motion-ease-spring); }
:is([data-anim="pop"], [data-anim="bubble"]):not(.is-shown) { transform: scale(var(--deck-pop-from)); }
[data-anim="grow"] { transform-origin: left center; }
[data-anim="grow"]:not(.is-shown) { transform: scaleX(0); }
[data-anim="draw"] {
  stroke-dasharray: var(--len);
  stroke-dashoffset: var(--len);
  transition: stroke-dashoffset var(--motion-dur-count) var(--motion-ease-out);
}
[data-anim="draw"].is-shown { stroke-dashoffset: calc(var(--len) * (1 - var(--draw-to, 1))); }

[data-stagger] > * {
  transition:
    opacity var(--motion-dur-slow) var(--motion-ease-out),
    transform var(--motion-dur-slow) var(--motion-ease-out);
  transition-delay: calc(var(--i, 0) * var(--motion-stagger));
}
[data-stagger]:not(.is-shown) > * { opacity: 0; transform: translateY(var(--space-md)); }

mark.hl {
  color: inherit;
  background: linear-gradient(var(--surface-highlight), var(--surface-highlight)) left / 0% 100% no-repeat;
  border-radius: var(--radius-xs);
  padding: 0 var(--space-xs);
  -webkit-box-decoration-break: clone;
  box-decoration-break: clone;
  transition: background-size var(--motion-dur-slow) var(--motion-ease-out) var(--motion-dur-base);
}
.is-shown mark.hl { background-size: 100% 100%; }

.deck-row { display: flex; align-items: center; gap: var(--space-lg); }
.deck-grow { flex: 1; min-width: 0; }
.deck-stack { display: flex; flex-direction: column; justify-content: center; gap: var(--space-md); }
.deck-center { align-items: center; text-align: center; }
.deck-text-center { text-align: center; }
.deck-kicker {
  font: var(--type-label);
  letter-spacing: var(--ls-body);
  text-transform: uppercase;
  color: inherit;
  opacity: var(--opacity-subtle);
}
.deck-lead {
  margin: 0;
  max-width: 40ch;
  font: var(--type-h4);
  letter-spacing: var(--ls-h4);
  color: var(--text-secondary);
}
.scene :is(h1, h2, h3, p, ul, ol) { margin: 0; }
.scene :is(ul, ol) { padding: 0; list-style: none; }

.deck-window {
  display: flex;
  flex-direction: column;
  overflow: hidden;
  border-radius: var(--radius-md);
  background: var(--surface-overlay);
  box-shadow: var(--shadow-floating);
}
.deck-window__bar {
  display: flex;
  align-items: center;
  gap: var(--space-xs);
  padding: var(--space-sm) var(--space-md);
  background: var(--surface-card);
}
.deck-window__dot { width: var(--space-sm); height: var(--space-sm); border-radius: var(--radius-full); }
.deck-window__dot:nth-child(1) { background: var(--semantic-error); }
.deck-window__dot:nth-child(2) { background: var(--semantic-warn); }
.deck-window__dot:nth-child(3) { background: var(--semantic-success); }
.deck-window__title { margin-left: var(--space-xs); font: var(--type-caption); color: var(--text-muted); }
.deck-window__body { position: relative; aspect-ratio: 16 / 10; }

.deck-screens { position: relative; flex: 1; }
.deck-screen {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  gap: var(--space-sm);
  padding: var(--space-md);
  overflow: hidden;
  background: var(--surface-page);
}
.deck-skel { display: block; flex-shrink: 0; height: var(--space-sm); border-radius: var(--radius-full); background: var(--surface-card); }
.deck-skel--title { height: var(--space-lg); width: 60%; }
.deck-skel--short { width: 40%; }
.deck-skel--mid { width: 70%; }
.deck-skel--block { height: var(--space-xxxxl); border-radius: var(--radius-md); }

.deck-device { zoom: var(--deck-device-scale); flex-shrink: 0; }
.deck-ring { width: var(--deck-ring-size); height: var(--deck-ring-size); }

.deck-bubble {
  display: inline-flex;
  align-items: center;
  gap: var(--space-md);
  border-bottom-left-radius: var(--radius-xs);
}
.deck-typing { display: inline-flex; gap: var(--space-xxs); }
.deck-typing > span {
  width: var(--space-xs);
  height: var(--space-xs);
  border-radius: var(--radius-full);
  background: currentColor;
  animation: deck-blink var(--motion-dur-slow) var(--motion-ease-out) infinite alternate;
}
.deck-typing > span:nth-child(2) { animation-delay: var(--motion-dur-fast); }
.deck-typing > span:nth-child(3) { animation-delay: var(--motion-dur-base); }
@keyframes deck-blink {
  from { opacity: var(--opacity-subtle); }
  to { opacity: var(--opacity-faint); }
}
.deck-bubble__message { display: none; }
.deck-bubble.is-typed .deck-typing { display: none; }
.deck-bubble.is-typed .deck-bubble__message { display: inline; }

.deck__progress {
  position: absolute;
  left: var(--space-xxxxl);
  right: var(--space-xxxxl);
  bottom: var(--space-lg);
  height: var(--border-lg);
  overflow: hidden;
  border-radius: var(--radius-full);
  background: var(--surface-card);
}
.deck__progress-bar {
  height: 100%;
  background: var(--surface-card-strong);
  transform: scaleX(var(--deck-progress, 0));
  transform-origin: left center;
  transition: transform var(--motion-dur-base) var(--motion-ease-out);
}

@media (prefers-reduced-motion: reduce) {
  .deck *, .deck *::before, .deck *::after {
    transition-duration: 0s !important;
    transition-delay: 0s !important;
    animation: none !important;
  }
}
```

- [ ] **Step 2: Write `deck/effects.js`**

```js
(function (root) {
  const cancels = new WeakMap();
  const reduced = () => root.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const token = name => parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));

  function track(element, cancel) {
    cancels.set(element, cancel);
  }

  function stop(element) {
    const cancel = cancels.get(element);
    if (cancel) cancel();
    cancels.delete(element);
  }

  function after(element, duration, action) {
    if (reduced()) {
      action();
      return;
    }
    const id = setTimeout(action, duration);
    track(element, () => clearTimeout(id));
  }

  function count(element) {
    const from = Number(element.dataset.countFrom || 0);
    const to = Number(element.dataset.countTo);
    if (reduced()) {
      element.textContent = String(to);
      return;
    }
    const duration = token("--motion-dur-count");
    const start = performance.now();
    let id = 0;
    const frame = now => {
      const progress = Math.min((now - start) / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      element.textContent = String(Math.round(from + (to - from) * eased));
      if (progress < 1) id = requestAnimationFrame(frame);
    };
    element.textContent = String(from);
    id = requestAnimationFrame(frame);
    track(element, () => cancelAnimationFrame(id));
  }

  function type(element) {
    const text = element.dataset.text;
    if (reduced()) {
      element.textContent = text;
      return;
    }
    let index = 0;
    element.textContent = "";
    const id = setInterval(() => {
      index += 1;
      element.textContent = text.slice(0, index);
      if (index >= text.length) clearInterval(id);
    }, token("--motion-type-char"));
    track(element, () => clearInterval(id));
  }

  function bubble(element) {
    after(element, token("--motion-dur-typing"), () => element.classList.add("is-typed"));
  }

  function check(element) {
    const input = element.querySelector("input[type=checkbox]");
    if (!input || !element.hasAttribute("data-done")) return;
    after(element, token("--motion-dur-slow"), () => {
      input.checked = true;
    });
  }

  const players = { count, type, bubble, check };

  function play(element) {
    stop(element);
    const player = players[element.dataset.anim];
    if (player) player(element);
  }

  function reset(element) {
    stop(element);
    const anim = element.dataset.anim;
    if (anim === "count") element.textContent = String(element.dataset.countFrom || 0);
    if (anim === "type") element.textContent = element.dataset.text;
    if (anim === "bubble") element.classList.remove("is-typed");
    if (anim === "check" && element.hasAttribute("data-done")) {
      element.querySelector("input[type=checkbox]").checked = false;
    }
  }

  function prepare(element) {
    const anim = element.dataset.anim;
    if (anim === "draw") {
      element.style.setProperty("--len", element.getTotalLength() + "px");
      if (element.dataset.drawTo) element.style.setProperty("--draw-to", element.dataset.drawTo);
    }
    if (anim === "type") element.dataset.text = element.textContent;
    if (anim === "count") element.textContent = String(element.dataset.countFrom || 0);
    if (element.hasAttribute("data-stagger")) {
      Array.from(element.children).forEach((child, index) => child.style.setProperty("--i", String(index)));
    }
  }

  root.DeckEffects = { play, reset, prepare };
})(window);
```

- [ ] **Step 3: Write `deck/deck.js`**

```js
(function () {
  const root = document.documentElement;
  const scenes = Array.from(document.querySelectorAll(".scene"));
  const progress = document.querySelector(".deck__progress-bar");
  const ANIMATED = "[data-anim], [data-step], [data-stagger]";
  const NEXT_KEYS = ["ArrowRight", "ArrowDown", " ", "PageDown"];
  const PREV_KEYS = ["ArrowLeft", "ArrowUp", "PageUp"];

  document.querySelectorAll(ANIMATED).forEach(DeckEffects.prepare);

  const stepOf = element => Number(element.dataset.step || 0);
  const animatedIn = scene => Array.from(scene.querySelectorAll(ANIMATED));
  const counts = scenes.map(scene => Math.max(0, ...animatedIn(scene).map(stepOf)));
  let position = DeckState.parseHash(counts, location.hash);

  function renderScene(scene, index) {
    const active = index === position.scene;
    scene.classList.toggle("is-active", active);
    scene.classList.toggle("is-past", index < position.scene);
    animatedIn(scene).forEach(element => {
      const shown = active && stepOf(element) <= position.step;
      const wasShown = element.classList.contains("is-shown");
      if (shown && !wasShown) DeckEffects.play(element);
      if (!shown && wasShown) DeckEffects.reset(element);
      element.classList.toggle("is-shown", shown);
    });
  }

  function render() {
    scenes.forEach(renderScene);
    if (progress) progress.style.setProperty("--deck-progress", String((position.scene + 1) / scenes.length));
    history.replaceState(null, "", DeckState.formatHash(position));
  }

  function go(target) {
    position = target;
    render();
  }

  const next = () => go(DeckState.next(counts, position));
  const prev = () => go(DeckState.prev(counts, position));

  function toggleFullscreen() {
    if (document.fullscreenElement) document.exitFullscreen();
    else root.requestFullscreen();
  }

  function onKey(event) {
    if (NEXT_KEYS.includes(event.key)) {
      event.preventDefault();
      next();
    } else if (PREV_KEYS.includes(event.key)) {
      event.preventDefault();
      prev();
    } else if (event.key && event.key.toLowerCase() === "f") {
      toggleFullscreen();
    }
  }

  function fit() {
    const style = getComputedStyle(root);
    const width = parseFloat(style.getPropertyValue("--deck-width"));
    const height = parseFloat(style.getPropertyValue("--deck-height"));
    root.style.setProperty("--deck-scale", String(Math.min(innerWidth / width, innerHeight / height)));
  }

  document.querySelectorAll("[data-next]").forEach(button => {
    button.addEventListener("click", event => {
      event.currentTarget.blur();
      next();
    });
  });
  addEventListener("keydown", onKey);
  addEventListener("resize", fit);
  fit();
  render();
})();
```

- [ ] **Step 4: Write `deck/template/index.html`** (starter + engine fixture)

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Deck Template</title>
<link rel="stylesheet" href="../../tokens.css">
<link rel="stylesheet" href="../../components.css">
<link rel="stylesheet" href="../deck.css">
</head>
<body class="deck" data-brand="coralCamo" data-style="lightRounded">
<main class="deck__stage">

<section class="scene deck-center" data-camera="fade">
  <span class="deck-kicker" data-anim="fade">Deck kit</span>
  <h1 class="t-display1" data-anim="rise">Your <mark class="hl">title</mark> here</h1>
  <p class="deck-lead" data-anim="rise">Press → to reveal the next step.</p>
  <button class="btn btn--filledA btn--big" data-step="1" data-anim="pop" data-next>Click me</button>
  <div class="card deck-bubble" data-step="2" data-anim="bubble">
    <span class="avatar avatar--sm"><span class="avatar__monogram">?</span></span>
    <span class="deck-typing"><span></span><span></span><span></span></span>
    <span class="deck-bubble__message t-h4">A question appears after typing.</span>
  </div>
</section>

<section class="scene" data-camera="zoom">
  <h2 class="t-h1" data-anim="rise">Effects</h2>
  <div class="deck-row">
    <div class="card deck-grow deck-stack" data-step="1" data-anim="rise">
      <span class="t-label">Counter</span>
      <span class="t-display1" data-step="1" data-anim="count" data-count-from="0" data-count-to="300">0</span>
    </div>
    <div class="card card--strong deck-grow" data-step="2" data-anim="grow"><span class="deck-kicker">grow</span></div>
    <ul class="list card deck-grow" data-step="3" data-stagger>
      <li class="list-item"><span class="list-item__title">First</span></li>
      <li class="list-item"><span class="list-item__title">Second</span></li>
      <li class="list-item"><span class="list-item__title">Third</span></li>
    </ul>
  </div>
  <div class="deck-row">
    <svg class="deck-ring progress-ring" viewBox="0 0 64 64">
      <circle class="progress-ring__track" cx="32" cy="32" r="26"/>
      <circle class="progress-ring__bar" cx="32" cy="32" r="26" data-step="4" data-anim="draw" data-draw-to="0.7"/>
    </svg>
    <div class="checkbox" data-step="5" data-anim="check" data-done><input type="checkbox"><span class="checkbox__box">✓</span>Done item ticks</div>
    <p class="t-h4" data-step="6" data-anim="type">Typewriter text.</p>
  </div>
</section>

<section class="scene" data-camera="pan-left">
  <div class="deck-row">
    <div class="deck-window deck-grow" data-anim="rise">
      <div class="deck-window__bar"><span class="deck-window__dot"></span><span class="deck-window__dot"></span><span class="deck-window__dot"></span><span class="deck-window__title">App window</span></div>
      <div class="deck-window__body deck-screens">
        <div class="deck-screen">
          <span class="deck-skel deck-skel--title"></span>
          <span class="deck-skel"></span>
          <span class="deck-skel deck-skel--mid"></span>
          <span class="deck-skel deck-skel--block"></span>
        </div>
        <div class="deck-screen" data-step="1" data-anim="fade">
          <ul class="list" data-step="1" data-stagger>
            <li class="list-item"><span class="list-item__main"><span class="list-item__title">Screen two, row one</span></span><span class="tag tag--success">Done</span></li>
            <li class="list-item"><span class="list-item__main"><span class="list-item__title">Screen two, row two</span></span><span class="tag tag--warn">Running</span></li>
          </ul>
        </div>
      </div>
    </div>
    <div class="device deck-device" data-anim="slide-left">
      <div class="statusbar"><span>9:41</span><span class="statusbar__notch"></span><span class="statusbar__battery">100</span></div>
      <div class="deck-screens">
        <div class="deck-screen">
          <span class="deck-skel deck-skel--title"></span>
          <span class="deck-skel deck-skel--block"></span>
          <span class="deck-skel deck-skel--mid"></span>
          <span class="deck-skel deck-skel--short"></span>
        </div>
      </div>
      <div class="home-indicator"></div>
    </div>
  </div>
</section>

<div class="deck__progress"><div class="deck__progress-bar"></div></div>
</main>
<script src="../deck-state.js"></script>
<script src="../effects.js"></script>
<script src="../deck.js"></script>
</body>
</html>
```

- [ ] **Step 5: Serve and open** — Run in background: `python3 -m http.server 8765 --directory /Users/omar.doucoure/Documents/OmApps/design-systems`. In Chrome (new tab) open `http://localhost:8765/design-system-web/deck/template/index.html`.

- [ ] **Step 6: Verify navigation via javascript_tool**

```js
const key = k => dispatchEvent(new KeyboardEvent("keydown", { key: k }));
const log = [location.hash];
key("ArrowRight"); log.push(location.hash, document.querySelector("[data-next]").classList.contains("is-shown"));
key("ArrowRight"); key("ArrowRight"); log.push(location.hash, document.querySelectorAll(".scene")[1].classList.contains("is-active"));
key("ArrowLeft"); log.push(location.hash);
log
```

Expected: `["#1.0", "#1.1", true, "#2.0", true, "#1.2"]`

- [ ] **Step 7: Visual check** — hash `#2.6` then reload; wait 2s; screenshot at scale 0.5. Expected: counter 300, grow card, 3 list rows, ring 70% drawn, checkbox checked, typed text, highlight visible on scene 1 (`#1.2`), progress bar visible. Fix any visual defect before commit.

- [ ] **Step 8: Token self-check**

Run: `grep -nE '#[0-9A-Fa-f]{3,6}\b|rgba?\(' deck/deck.css deck/template/index.html; grep -n 'px' deck/deck.css`
Expected: first grep empty; second grep only the `--deck-width`, `--deck-height`, `--deck-ring-size` lines.

- [ ] **Step 9: Line limit** — `wc -l deck/*.css deck/*.js` each < 400.

- [ ] **Step 10: Commit**

```bash
git add deck/deck.css deck/effects.js deck/deck.js deck/template/index.html
git commit -m "Add motion deck engine and starter template"
```

---

### Task 4: Ship and document the kit

**Files:**
- Modify: `design-system-web/package.json` (`files`), `design-system-web/README.md` (new section before `### Code`… appended at end)

- [ ] **Step 1: Add `"deck/"` to `files`** in `package.json` after `"components.css",`.

- [ ] **Step 2: Append README section**

````markdown
## Deck kit

Click-driven presentations built only from DS tokens and components. Copy `deck/template/index.html` into a new folder, fix the three relative paths to `tokens.css`, `components.css`, `deck/deck.css` and the three scripts, then write scenes.

```html
<section class="scene" data-camera="zoom">
  <h1 class="t-display1" data-anim="rise">On est <mark class="hl">AI first</mark></h1>
  <button class="btn btn--filledA btn--big" data-step="1" data-anim="pop" data-next>Vraiment ?</button>
</section>
```

| Attribute | Values |
|---|---|
| `data-step` | reveal order in the scene; absent = visible on entry |
| `data-anim` | `rise` `fade` `pop` `slide-left` `slide-right` `grow` `draw` `count` `type` `bubble` `check` |
| `data-stagger` | children reveal one after another |
| `data-camera` | `fade` `zoom` `pan-left` `pan-up` |
| `data-next` | button advances the deck |
| `data-count-from`, `data-count-to` | counter range |
| `data-draw-to` | fraction of an SVG path to draw |
| `data-done` | `check` item ticks its checkbox |

| Key | Action |
|---|---|
| → ↓ Space PageDown | next step or scene |
| ← ↑ PageUp | previous |
| F | fullscreen |

URL hash `#scene.step` resumes a position. Screens are mockups, never screenshots: stack `.deck-screen` panels inside `.deck-screens` (in a `.deck-window__body` or a `.device.deck-device`), fill them with DS components and `.deck-skel` bars, and switch panels with `data-step` + `data-anim="fade"`. `mark.hl` sweeps when its animated parent appears.
````

- [ ] **Step 3: Verify** — `npm pack --dry-run 2>&1 | grep deck/` lists `deck/deck.css`, `deck/deck.js`, `deck/effects.js`, `deck/deck-state.js`.

- [ ] **Step 4: Commit**

```bash
git add package.json README.md
git commit -m "Document and ship the deck kit"
```

---

### Task 5: PFU Studio talk, scenes 1–5

**Files:**
- Create: `design-system-web/deck/patterns.css` (commit in design-system-web), `design-systems/presentation/pfu-studio/index.html` (commit in design-systems)
- A talk must need zero custom CSS: every class the talk uses lives in `deck.css` or `patterns.css`.

**Interfaces:**
- Consumes: kit API (Task 3). Kit path from talk: `../../design-system-web/`.
- Produces: talk file whose `<main class="deck__stage">` Task 6 appends scenes 6–10 to, before `<div class="deck__progress">`.

- [ ] **Step 1: Write `design-system-web/deck/patterns.css`**

```css
.deck-hero-window { width: 55%; flex-shrink: 0; }
.deck-island { display: flex; flex-direction: column; gap: var(--space-md); }
.deck-tags { display: flex; flex-wrap: wrap; gap: var(--space-xs); }
.deck-link { flex-shrink: 0; width: var(--space-xxxl); height: var(--border-md); background: var(--border-strong); }
.deck-hub { display: flex; flex-direction: column; gap: var(--space-xxs); flex-shrink: 0; text-align: center; }
.deck-teams { display: flex; flex-direction: column; gap: var(--space-sm); }
.deck-teams > .card { padding: var(--space-md) var(--space-lg); }
.deck-agenda .list-item { padding: var(--space-md) var(--space-lg); }
.deck-metrics { align-items: stretch; height: 50%; }
.deck-metric { display: flex; flex-direction: column; gap: var(--space-sm); overflow: hidden; }
.deck-queue .list-item { min-height: 0; padding: var(--space-xs) 0; }
.deck-gauge { position: relative; align-self: center; }
.deck-gauge .progress-ring__bar { stroke: var(--semantic-error); }
.deck-gauge__label { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; }
.deck-questions { display: flex; flex-wrap: wrap; justify-content: center; gap: var(--space-sm); }
.deck-versus { display: flex; flex-direction: column; gap: var(--space-sm); padding: var(--space-xxl) var(--space-xl); }
.deck-orbit { position: relative; flex: 1; }
.deck-orbit__rings { position: absolute; inset: 0; width: 100%; height: 100%; }
.deck-orbit__rings ellipse { fill: none; stroke: var(--border-default); stroke-width: var(--border-md); }
.deck-orbit__hub { position: absolute; left: 50%; top: 50%; translate: -50% -50%; }
.deck-orbit__nodes { position: absolute; inset: 0; }
.deck-node {
  position: absolute;
  translate: -50% -50%;
  display: inline-flex;
  align-items: center;
  gap: var(--space-xs);
  padding: var(--space-xs) var(--space-md) var(--space-xs) var(--space-xs);
  border-radius: var(--radius-full);
  white-space: nowrap;
  box-shadow: var(--shadow-card);
}
.deck-node--left { left: 7%; top: 50%; }
.deck-node--upper-left { left: 17%; top: 19%; }
.deck-node--lower-left { left: 17%; top: 81%; }
.deck-node--upper-right { left: 83%; top: 19%; }
.deck-node--lower-right { left: 83%; top: 81%; }
.deck-node--right { left: 93%; top: 50%; }
.deck-node--bottom { left: 50%; top: 94%; }
.deck-demo { align-items: center; }
.deck-roadmap { display: flex; flex-direction: column; gap: var(--space-md); }
.deck-roadmap .checkbox { font: var(--type-h5); letter-spacing: var(--ls-h4); }
```

- [ ] **Step 2: Write `index.html` with scenes 1–5**

```html
<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>PFU Studio</title>
<link rel="stylesheet" href="../../design-system-web/tokens.css">
<link rel="stylesheet" href="../../design-system-web/components.css">
<link rel="stylesheet" href="../../design-system-web/deck/deck.css">
<link rel="stylesheet" href="../../design-system-web/deck/patterns.css">
</head>
<body class="deck" data-brand="coralCamo" data-style="lightRounded">
<main class="deck__stage">

<section class="scene" data-camera="fade">
  <div class="deck-row">
    <div class="deck-stack deck-grow">
      <span class="deck-kicker" data-anim="fade">Équipe mobile · Québecor</span>
      <h1 class="t-display1" data-anim="rise"><mark class="hl">PFU Studio</mark></h1>
      <p class="deck-lead" data-anim="rise">Relier l'équipe mobile au reste de l'entreprise, et préparer l'entreprise à l'IA.</p>
    </div>
    <div class="deck-window deck-hero-window" data-step="1" data-anim="slide-left">
      <div class="deck-window__bar"><span class="deck-window__dot"></span><span class="deck-window__dot"></span><span class="deck-window__dot"></span><span class="deck-window__title">PFU Studio</span></div>
      <div class="deck-window__body deck-screens">
        <div class="deck-screen">
          <span class="deck-skel deck-skel--title"></span>
          <ul class="list" data-step="1" data-stagger>
            <li class="list-item"><span class="list-item__leading"><span class="avatar avatar--xs"><span class="avatar__monogram">K</span></span></span><span class="list-item__main"><span class="list-item__title">Kim · analyse du ticket</span></span><span class="tag tag--success">Terminé</span></li>
            <li class="list-item"><span class="list-item__leading"><span class="avatar avatar--xs"><span class="avatar__monogram">C</span></span></span><span class="list-item__main"><span class="list-item__title">Cody · build simulateur</span></span><span class="tag tag--success">Terminé</span></li>
            <li class="list-item"><span class="list-item__leading"><span class="avatar avatar--xs"><span class="avatar__monogram">M</span></span></span><span class="list-item__main"><span class="list-item__title">Maestro · parcours UI</span></span><span class="tag tag--warn">En cours</span></li>
          </ul>
          <span class="deck-skel deck-skel--mid"></span>
          <span class="deck-skel deck-skel--short"></span>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="scene" data-camera="pan-left">
  <span class="deck-kicker" data-anim="fade">Au programme</span>
  <ol class="list card deck-agenda" data-stagger>
    <li class="list-item"><span class="list-item__leading"><span class="avatar avatar--md"><span class="avatar__monogram">1</span></span></span><span class="list-item__main"><span class="list-item__title t-h4">Pourquoi PFU Studio ?</span><span class="list-item__support">Relier l'équipe mobile aux autres équipes</span></span></li>
    <li class="list-item"><span class="list-item__leading"><span class="avatar avatar--md"><span class="avatar__monogram">2</span></span></span><span class="list-item__main"><span class="list-item__title t-h4">L'objectif</span><span class="list-item__support">Être AI ready, pas seulement AI first</span></span></li>
    <li class="list-item"><span class="list-item__leading"><span class="avatar avatar--md"><span class="avatar__monogram">3</span></span></span><span class="list-item__main"><span class="list-item__title t-h4">La suite</span><span class="list-item__support">PFU Studio, cœur de la préparation à l'IA</span></span></li>
  </ol>
</section>

<section class="scene" data-camera="pan-left">
  <span class="deck-kicker" data-anim="fade">1 · Pourquoi</span>
  <h2 class="t-h1" data-anim="rise">Relier l'équipe mobile au reste de l'entreprise</h2>
  <div class="deck-row">
    <div class="card card--strong deck-island deck-grow" data-step="1" data-anim="rise">
      <span class="t-h4">Équipe mobile</span>
      <span class="t-body-regular">Natif, en bac à sable : pour voir un changement, il faut compiler, simuler, préparer un environnement.</span>
      <div class="deck-tags"><span class="tag tag--lg tag--brand">Compilation</span><span class="tag tag--lg tag--brand">Simulateur</span><span class="tag tag--lg tag--brand">Environnement</span></div>
    </div>
    <span class="deck-link" data-step="3" data-anim="grow"></span>
    <div class="card card--accent deck-hub" data-step="3" data-anim="pop"><span class="t-h4">PFU Studio</span><span class="t-caption">compile · simule · partage</span></div>
    <span class="deck-link" data-step="3" data-anim="grow"></span>
    <div class="deck-teams deck-grow" data-step="2" data-stagger>
      <div class="card"><span class="t-h5">QA</span></div>
      <div class="card"><span class="t-h5">Design</span></div>
      <div class="card"><span class="t-h5">Produit · PO</span></div>
    </div>
  </div>
</section>

<section class="scene deck-center" data-camera="zoom">
  <span class="deck-kicker" data-anim="fade">2 · L'objectif</span>
  <h2 class="t-display1" data-anim="rise">On est <mark class="hl">AI first</mark>.</h2>
  <button class="btn btn--filledA btn--big" data-step="1" data-anim="pop" data-next>Vraiment ?</button>
  <div class="card deck-bubble" data-step="2" data-anim="bubble">
    <span class="avatar avatar--md"><span class="avatar__monogram">?</span></span>
    <span class="deck-typing"><span></span><span></span><span></span></span>
    <span class="deck-bubble__message t-h3">Mais… sommes-nous prêts ?</span>
  </div>
</section>

<section class="scene" data-camera="pan-left">
  <span class="deck-kicker" data-anim="fade">2 · L'objectif</span>
  <h2 class="t-h1" data-anim="rise">Le paradoxe de productivité de l'IA</h2>
  <div class="deck-row deck-metrics">
    <div class="card deck-metric deck-grow" data-step="1" data-anim="rise">
      <span class="t-label">Pull requests par semaine</span>
      <span class="t-display1" data-step="1" data-anim="count" data-count-from="12" data-count-to="140">12</span>
      <span class="tag tag--lg tag--success">Code généré par l'IA</span>
    </div>
    <div class="card deck-metric deck-grow" data-step="2" data-anim="rise">
      <span class="t-label">File d'attente QA</span>
      <ul class="list deck-queue" data-step="2" data-stagger>
        <li class="list-item"><span class="list-item__main"><span class="list-item__title">PR #1042 · Paiement</span></span><span class="tag tag--warn">En attente</span></li>
        <li class="list-item"><span class="list-item__main"><span class="list-item__title">PR #1043 · Profil</span></span><span class="tag tag--warn">En attente</span></li>
        <li class="list-item"><span class="list-item__main"><span class="list-item__title">PR #1044 · Lecteur</span></span><span class="tag tag--warn">En attente</span></li>
        <li class="list-item"><span class="list-item__main"><span class="list-item__title">PR #1045 · Accueil</span></span><span class="tag tag--warn">En attente</span></li>
        <li class="list-item"><span class="list-item__main"><span class="list-item__title">PR #1046 · Recherche</span></span><span class="tag tag--warn">En attente</span></li>
        <li class="list-item"><span class="list-item__main"><span class="list-item__title">PR #1047 · Connexion</span></span><span class="tag tag--warn">En attente</span></li>
        <li class="list-item"><span class="list-item__main"><span class="list-item__title">PR #1048 · Réglages</span></span><span class="tag tag--warn">En attente</span></li>
      </ul>
    </div>
    <div class="card deck-metric deck-grow" data-step="3" data-anim="rise">
      <span class="t-label">Capacité de revue humaine</span>
      <div class="deck-gauge">
        <svg class="deck-ring progress-ring" viewBox="0 0 64 64">
          <circle class="progress-ring__track" cx="32" cy="32" r="26"/>
          <circle class="progress-ring__bar" cx="32" cy="32" r="26" data-step="3" data-anim="draw" data-draw-to="0.18"/>
        </svg>
        <span class="deck-gauge__label t-h3">18 %</span>
      </div>
    </div>
  </div>
  <div class="deck-questions" data-step="4" data-stagger>
    <span class="tag tag--lg tag--error">La QA est-elle prête ?</span>
    <span class="tag tag--lg tag--error">Qui relit tout ce code ?</span>
    <span class="tag tag--lg tag--error">Et la qualité ?</span>
    <span class="tag tag--lg tag--error">Notre workflow suit-il ?</span>
  </div>
</section>

<div class="deck__progress"><div class="deck__progress-bar"></div></div>
</main>
<script src="../../design-system-web/deck/deck-state.js"></script>
<script src="../../design-system-web/deck/effects.js"></script>
<script src="../../design-system-web/deck/deck.js"></script>
</body>
</html>
```

- [ ] **Step 3: Verify** — open `http://localhost:8765/presentation/pfu-studio/index.html#5.4`, reload, wait 2s, screenshot scale 0.5. Expected: 140 counter, 7 queue rows clipped by card, red ring 18 %, 4 red question tags. Check `#4.2` after 2s: bubble shows "Mais… sommes-nous prêts ?". Check `#3.3`: lines + PFU Studio hub between the mobile card and team cards. Fix overflow/contrast issues in `scenes.css` before commit.

- [ ] **Step 4: Commit** — in design-system-web: `git add deck/patterns.css && git commit -m "Add reusable deck scene patterns"`; then in design-systems:

```bash
git add presentation/pfu-studio
git commit -m "Add PFU Studio talk scenes 1 to 5"
```

---

### Task 6: PFU Studio talk, scenes 6–10

**Files:**
- Modify: `presentation/pfu-studio/index.html` (insert before `<div class="deck__progress">`)

- [ ] **Step 1: Insert scenes**

```html
<section class="scene" data-camera="zoom">
  <div class="deck-row">
    <div class="card deck-versus deck-grow" data-step="1" data-anim="slide-right">
      <span class="deck-kicker">Le slogan</span>
      <span class="t-display2">AI first</span>
      <span class="t-h5">Générer plus de code, plus vite.</span>
    </div>
    <div class="card card--strong deck-versus deck-grow" data-step="2" data-anim="slide-left">
      <span class="deck-kicker">La capacité</span>
      <span class="t-display2">AI ready</span>
      <span class="t-h5">Tester, relire et livrer ce code avec confiance.</span>
    </div>
  </div>
  <p class="t-h3 deck-text-center" data-step="3" data-anim="rise">On peut être AI first sans être <mark class="hl">AI ready</mark>.</p>
</section>

<section class="scene" data-camera="zoom">
  <span class="deck-kicker" data-anim="fade">3 · La suite</span>
  <h2 class="t-h1" data-anim="rise">PFU Studio, le cœur du <mark class="hl">AI ready</mark></h2>
  <div class="deck-orbit">
    <svg class="deck-orbit__rings" viewBox="0 0 1150 460">
      <ellipse cx="575" cy="230" rx="540" ry="200" data-step="1" data-anim="draw"/>
      <ellipse cx="575" cy="230" rx="360" ry="130" data-step="1" data-anim="draw"/>
    </svg>
    <div class="card card--accent deck-hub deck-orbit__hub" data-anim="pop"><span class="t-h3">PFU Studio</span><span class="t-caption">orchestrateur multi-agents</span></div>
    <div class="deck-orbit__nodes" data-step="2" data-stagger>
      <div class="card deck-node deck-node--left"><span class="avatar avatar--xs"><span class="avatar__monogram">K</span></span><span class="t-label">Kim · analyse</span></div>
      <div class="card deck-node deck-node--upper-left"><span class="avatar avatar--xs"><span class="avatar__monogram">C</span></span><span class="t-label">Cody · code</span></div>
      <div class="card deck-node deck-node--upper-right"><span class="avatar avatar--xs"><span class="avatar__monogram">A</span></span><span class="t-label">Arthur · architecture</span></div>
      <div class="card deck-node deck-node--right"><span class="avatar avatar--xs"><span class="avatar__monogram">M</span></span><span class="t-label">Maestro · tests UI</span></div>
      <div class="card deck-node deck-node--lower-right"><span class="avatar avatar--xs"><span class="avatar__monogram">S</span></span><span class="t-label">Simulateur iOS · tvOS</span></div>
      <div class="card deck-node deck-node--bottom"><span class="avatar avatar--xs"><span class="avatar__monogram">V</span></span><span class="t-label">Verdicts QA</span></div>
      <div class="card deck-node deck-node--lower-left"><span class="avatar avatar--xs"><span class="avatar__monogram">J</span></span><span class="t-label">Jira · Confluence</span></div>
    </div>
  </div>
</section>

<section class="scene" data-camera="pan-up">
  <span class="deck-kicker" data-anim="fade">Démo</span>
  <div class="deck-row deck-demo">
    <div class="deck-window deck-grow" data-anim="rise">
      <div class="deck-window__bar"><span class="deck-window__dot"></span><span class="deck-window__dot"></span><span class="deck-window__dot"></span><span class="deck-window__title">PFU Studio</span></div>
      <div class="deck-window__body deck-screens">
        <div class="deck-screen">
          <span class="t-label">Ticket Jira · PFU-1234</span>
          <span class="deck-skel deck-skel--title"></span>
          <span class="deck-skel"></span>
          <span class="deck-skel deck-skel--mid"></span>
          <span class="deck-skel deck-skel--short"></span>
          <span class="deck-skel deck-skel--block"></span>
        </div>
        <div class="deck-screen" data-step="1" data-anim="fade">
          <span class="t-label">Agents en action</span>
          <ul class="list" data-step="1" data-stagger>
            <li class="list-item"><span class="list-item__leading"><span class="avatar avatar--xs"><span class="avatar__monogram">K</span></span></span><span class="list-item__main"><span class="list-item__title">Kim · critères d'acceptation</span></span><span class="tag tag--success">Terminé</span></li>
            <li class="list-item"><span class="list-item__leading"><span class="avatar avatar--xs"><span class="avatar__monogram">C</span></span></span><span class="list-item__main"><span class="list-item__title">Cody · build et installation</span></span><span class="tag tag--success">Terminé</span></li>
            <li class="list-item"><span class="list-item__leading"><span class="avatar avatar--xs"><span class="avatar__monogram">M</span></span></span><span class="list-item__main"><span class="list-item__title">Maestro · parcours de test</span></span><span class="tag tag--warn">En cours</span></li>
          </ul>
        </div>
        <div class="deck-screen" data-step="2" data-anim="fade">
          <span class="t-label">Verdict QA</span>
          <span class="tag tag--lg tag--success">Validé · 12 / 12 étapes</span>
          <span class="deck-skel deck-skel--mid"></span>
          <span class="deck-skel"></span>
          <span class="deck-skel deck-skel--short"></span>
        </div>
      </div>
    </div>
    <div class="device deck-device" data-anim="slide-left">
      <div class="statusbar"><span>9:41</span><span class="statusbar__notch"></span><span class="statusbar__battery">100</span></div>
      <div class="deck-screens">
        <div class="deck-screen">
          <span class="deck-skel deck-skel--title"></span>
          <span class="deck-skel deck-skel--block"></span>
          <span class="deck-skel deck-skel--mid"></span>
          <span class="deck-skel deck-skel--block"></span>
          <span class="deck-skel deck-skel--short"></span>
        </div>
        <div class="deck-screen" data-step="1" data-anim="fade">
          <span class="deck-skel deck-skel--title"></span>
          <div class="checkbox" data-step="1" data-anim="check" data-done><input type="checkbox"><span class="checkbox__box">✓</span>Connexion</div>
          <div class="checkbox" data-step="2" data-anim="check" data-done><input type="checkbox"><span class="checkbox__box">✓</span>Lecture vidéo</div>
          <span class="deck-skel deck-skel--block"></span>
        </div>
      </div>
      <div class="home-indicator"></div>
    </div>
  </div>
</section>

<section class="scene" data-camera="pan-left">
  <span class="deck-kicker" data-anim="fade">3 · La suite</span>
  <h2 class="t-h1" data-anim="rise">Prochaines étapes</h2>
  <div class="card deck-roadmap">
    <div class="checkbox" data-step="1" data-anim="check" data-done><input type="checkbox"><span class="checkbox__box">✓</span>Relier l'équipe mobile à QA, Design et Produit</div>
    <div class="checkbox" data-step="2" data-anim="check" data-done><input type="checkbox"><span class="checkbox__box">✓</span>Orchestrer des agents IA sur le simulateur</div>
    <div class="checkbox" data-step="3" data-anim="check"><input type="checkbox"><span class="checkbox__box">✓</span>Verdicts QA automatiques sur chaque pull request</div>
    <div class="checkbox" data-step="4" data-anim="check"><input type="checkbox"><span class="checkbox__box">✓</span>Préparer la revue humaine : résumé et risques par PR</div>
    <div class="checkbox" data-step="5" data-anim="check"><input type="checkbox"><span class="checkbox__box">✓</span>Étendre à toutes les apps : TVA Nouvelles, TVA Sports, Club illico, 24 heures</div>
  </div>
</section>

<section class="scene deck-center" data-camera="fade">
  <h2 class="t-display1" data-anim="rise"><mark class="hl">Merci</mark></h2>
  <p class="deck-lead" data-anim="rise">Questions ?</p>
</section>
```

- [ ] **Step 2: Verify** — screenshots at scale 0.5 for `#6.3`, `#7.2`, `#8.2`, `#9.5`, `#10.0` (reload + wait 2s each). Expected: versus cards with sweep; orbit ellipses drawn with 7 nodes not clipped at stage edges; demo window shows verdict mock screen and phone shows two ticked checks; roadmap first two ticked; Merci highlighted. Adjust `.deck-node--*` percentages if nodes overlap rings badly or clip.

- [ ] **Step 3: Commit**

```bash
git add presentation/pfu-studio/index.html
git commit -m "Add PFU Studio talk scenes 6 to 10"
```

---

### Task 7: Full run-through and checks

- [ ] **Step 1: Keyboard run** — open `#1.0`, press → until the end via javascript_tool, collecting `location.hash` each press. Expected final hash `#10.0`, no console errors (`read_console_messages`).
- [ ] **Step 2: Backward run** — ← to `#1.0`; every scene reached.
- [ ] **Step 3: Token grep** — `grep -nE '#[0-9A-Fa-f]{3,6}\b|rgba?\(|[0-9]px' design-system-web/deck/patterns.css presentation/pfu-studio/index.html` → only `#1042`… PR labels in HTML text, no CSS literals.
- [ ] **Step 4: Line limits** — `wc -l presentation/pfu-studio/*` each < 400.
- [ ] **Step 5: Offline check** — open `file:///Users/omar.doucoure/Documents/OmApps/design-systems/presentation/pfu-studio/index.html` directly; fonts render DM Sans, navigation works.
- [ ] **Step 6: Stop server**, close Chrome tabs.

---

### Task 8: Story-to-deck skill + scene pattern catalog

Goal: a new talk from one prompt ("make a deck: <story>") with zero hand-written CSS and no images.

**Files:**
- Create: `design-system-web/deck/PATTERNS.md`, `design-system-web/deck/new-deck.sh`
- Modify: `design-system-web/README.md` (Deck kit section: one line pointing to `deck/PATTERNS.md` and `new-deck.sh`)
- Create: `~/.claude/skills/motion-deck/SKILL.md` (not in any repo)

**Interfaces:**
- Consumes: kit files (Tasks 1–4), `deck/patterns.css` (Task 5), final `presentation/pfu-studio/index.html` and `deck/template/index.html` as snippet sources.
- Produces: `deck/new-deck.sh <dest-dir> "<title>" [lang]` → self-contained folder: `<dest>/index.html` (skeleton, one title scene) + `<dest>/kit/` (copies of `tokens.css`, `components.css`, `fonts/`, `deck/deck.css`, `deck/patterns.css`, `deck/deck-state.js`, `deck/effects.js`, `deck/deck.js`). Talk HTML links `kit/...`. Folder works when zipped or moved anywhere.

- [ ] **Step 1: `deck/new-deck.sh`** (bash, `set -euo pipefail`, no comments): resolve kit dir from script location; fail with usage if dest missing or dest exists and not empty; copy files listed above into `<dest>/kit/` keeping `deck/` subfolder; write `<dest>/index.html` = template head/body skeleton with paths `kit/tokens.css`, `kit/components.css`, `kit/deck/deck.css`, `kit/deck/patterns.css`, scripts `kit/deck/deck-state.js`, `kit/deck/effects.js`, `kit/deck/deck.js`, `<html lang>` = arg 3 (default `fr`), `<title>` = arg 2, one `deck-center` title scene with `<mark class="hl">` title, and the progress bar. Test: `bash deck/new-deck.sh "$SCRATCH/demo" "Demo"` → folder exists, `ls "$SCRATCH/demo/kit/deck"` lists 5 files, opening `$SCRATCH/demo/index.html` over localhost shows title with highlight and `location.hash === "#1.0"`. Second run on same dest → non-zero exit with message.

- [ ] **Step 2: `deck/PATTERNS.md`** — catalog, one section per pattern, each with: **Use when** (story beat it serves), **Steps** (what each click reveals), **Snippet** (complete `<section class="scene">…</section>` copied from the PFU talk or template, content genericized to English placeholders in `[brackets]`). Patterns, in this order:
  1. `title-window` — title + lead + app window mock (PFU scene 1)
  2. `agenda` — numbered staggered list (PFU scene 2)
  3. `bridge` — isolated team card, other teams, lines grow, hub pops (PFU scene 3)
  4. `question` — kinetic headline → `data-next` button → typing bubble (PFU scene 4)
  5. `metrics` — counter card, overflowing queue, gauge, question tags (PFU scene 5)
  6. `versus` — two cards slide in, conclusion with highlight (PFU scene 6)
  7. `orbit` — hub with drawn ellipses and up to 7 nodes (PFU scene 7; list the 7 `deck-node--*` position modifiers)
  8. `demo` — window + phone, mock screens switching (PFU scene 8)
  9. `roadmap` — checklist, done items tick (PFU scene 9)
  10. `closing` — thank-you (PFU scene 10)
  Top of file: rules (only kit classes, no images, no inline styles, mock screens use `.deck-screen` + DS components + `.deck-skel`, reveal attributes table from README, camera per pattern suggestion). Keep under 400 lines; if longer, keep snippets and shorten prose.

- [ ] **Step 3: Skill `~/.claude/skills/motion-deck/SKILL.md`** — follow `~/.claude/skills-guide.md`. Frontmatter: `name: motion-deck`; description (what + when): builds an animated, click-through HTML presentation from a story using the HaHo design system deck kit; triggers "make a presentation", "deck", "slides", "présentation", "animated presentation like a video", "turn this story into slides"; negative trigger: not for .pptx/Google Slides requests. Body sections:
  - `## Critical`: only kit classes and DS components; zero custom CSS; no images or screenshots, screens are mockups; one idea per scene; ≤ 6 steps per scene; text in the language of the story; no code comments.
  - `## Step 1: Outline` — split story into beats; map each beat to a pattern from `/Users/omar.doucoure/Documents/OmApps/design-systems/design-system-web/deck/PATTERNS.md` (read it first); show the outline as a table (`# | Scene | Pattern | Clicks reveal`) and ask for approval once.
  - `## Step 2: Scaffold` — `bash /Users/omar.doucoure/Documents/OmApps/design-systems/design-system-web/deck/new-deck.sh <dest> "<title>" <lang>`; default dest `~/Documents/Presentations/<slug>`.
  - `## Step 3: Write scenes` — replace the skeleton scene with pattern snippets, filled with the story's content.
  - `## Step 4: Verify` — serve dest with `python3 -m http.server` in background, step through every scene with keydown events in Chrome, screenshot each scene at scale 0.5, fix overflow/contrast, grep for `#hex|rgb|px|style=` in index.html (must be empty except text).
  - `## Step 5: Hand off` — table of scenes + how to present (open `index.html`, → / ← / clicker, F fullscreen, `#scene.step`).
  - `## Examples`: the PFU Studio talk (`/Users/omar.doucoure/Documents/OmApps/design-systems/presentation/pfu-studio/index.html`) as the reference deck.
  - `## Troubleshooting`: text overflows card → shorten text or split scene; nodes clip in orbit → max 7 nodes, shorter labels; animation doesn't play → element needs `data-anim`/`data-step`, `mark.hl` needs an animated ancestor.

- [ ] **Step 4: Trigger + function test** — in a fresh subagent with no context, give only: "Fais-moi une présentation animée : notre équipe a réduit le temps de build de 20 à 5 minutes. Pourquoi c'était lent, ce qu'on a changé, les résultats, la suite." and let it follow the skill end to end into `$SCRATCH/test-deck`. Expected: outline table, folder built by `new-deck.sh`, ≥ 5 scenes from ≥ 4 different patterns, no custom CSS, navigation works. Fix skill/PATTERNS gaps it hits.

- [ ] **Step 5: Commit** — design-system-web: `git add deck/PATTERNS.md deck/new-deck.sh README.md && git commit -m "Add deck pattern catalog and scaffolding script"`. The skill folder is outside repos; no commit.

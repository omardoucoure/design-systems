# Motion Deck Kit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reusable click-driven HTML deck kit built on the HaHo web design system, plus a reproduction of the AI LABS "Helix Loops" video (English) built with it, and a skill that turns any story into a deck.

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
| `presentation/helix-loops/index.html` | design-systems | 17 scenes |
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

### Task 5: Helix Loops reproduction, patterns + scenes 1–9

Reproduction, in our design system, of the AI LABS video "Shopify Just Released The Greatest AI Coding Workflow Ever" (youtube bBMp5tLxShQ). English. Paraphrase; never copy transcript sentences verbatim; no Shopify logo (text only). Sponsor and subscribe segments excluded.

**Files:**
- Create: `design-system-web/deck/patterns.css` (commit in design-system-web)
- Create: `design-systems/presentation/helix-loops/index.html` (commit in design-systems)

**Interfaces:**
- Consumes: kit API from Task 3 (`deck.css` classes and attributes, `DeckEffects`), `deck/template/index.html` as skeleton reference (head, stage, progress bar, script order). Kit path from talk: `../../design-system-web/`.
- Produces: `patterns.css` classes (all `deck-` prefixed, generic names, reusable by any talk). Task 6 appends scenes 10–17 before `<div class="deck__progress">` and may add patterns to `patterns.css`.
- A talk needs zero custom CSS and no `style=` attributes: every class lives in `deck.css` or `patterns.css`.

**Pattern classes to provide in `patterns.css`** (tokens only; px only allowed in a `:root` block of `--deck-*` tokens if unavoidable):

| Class | Purpose |
|---|---|
| `.deck-hub` | accent card, column, centered text, no shrink |
| `.deck-link` | horizontal connector line (`--border-md` high, `--border-strong`), used with `data-anim="grow"` |
| `.deck-flow` | horizontal chain: items + `.deck-link` between them, wraps nothing, centered |
| `.deck-flow__item` | small card in a chain (title + caption) |
| `.deck-screen-grid` | dense grid of mini screens (e.g. 10 columns) |
| `.deck-mini` | mini screen: card with 3 `.deck-skel` bars, phone proportions |
| `.deck-versus` | padded column card for side-by-side comparisons |
| `.deck-stairs` | row of cards bottom-aligned, each taller than the previous (`.deck-stairs > *:nth-child(n)` heights from spacing tokens) |
| `.deck-metrics`, `.deck-metric` | stretched row of metric cards, overflow hidden |
| `.deck-gauge`, `.deck-gauge__label` | progress-ring wrapper sized `--deck-ring-size`, centered label |
| `.deck-gauge--alert` | ring bar in `--semantic-error` |
| `.deck-bar`, `.deck-bar__fill` | horizontal context-window bar; fill uses `data-anim="grow"`; `.deck-bar--alert` fill in `--semantic-error` |
| `.deck-orbit`, `.deck-orbit__rings`, `.deck-orbit__hub`, `.deck-orbit__nodes`, `.deck-node`, `.deck-node--left`, `--upper-left`, `--lower-left`, `--upper-right`, `--lower-right`, `--right`, `--bottom` | orbit diagram: SVG ellipses drawn with `data-anim="draw"`, hub centered, up to 7 pill nodes (avatar + label); centering via `translate` property so `transform` stays free for animations |
| `.deck-loop` | two cards facing each other with two arrows between (`→` top, `←` bottom) |
| `.deck-compare` | two device mockups side by side with a verdict between |
| `.deck-checklist` | column of `.checkbox` rows, h5 type |
| `.deck-tags` | wrap row of tags |
| `.deck-quote` | large centered statement |

**Scenes 1–9** (each `section.scene`, `data-camera` varied: fade/zoom/pan-left/pan-up):

| # | Beat | Content and reveal steps |
|---|---|---|
| 1 | Hook | kicker "Shopify mobile"; h1 "Rebuilt with AI agents"; `deck-screen-grid` of 40 `deck-mini` (stagger, step 1); big counter `data-anim="count"` 0 → 300 with label "screens" (step 1) |
| 2 | Not one prompt | `deck-versus` pair: left card "One giant prompt" with a bubble "Build the whole app" and tag--error "Drifts, forgets, breaks"; right `card--strong` "A structured loop" with tags "Plan · Build · Check · Repeat" (steps 1, 2); conclusion line with `mark.hl` "a process the agent can't talk its way out of" (step 3) |
| 3 | Title | `t-display1` "<mark class=hl>Helix</mark> Loops" + orbit: 2 ellipses draw (step 1), hub card "Helix", 5 nodes pop (step 2): Terminal, Tasks, Git, Search, Bugs (monogram avatars T, ✓, G, S, B) |
| 4 | How Helix works | `deck-flow`: Old screen → Agent → Checkpoints → Human review → 4 gates → Next checkpoint; items and links reveal left to right over steps 1–5 |
| 5 | Fresh context | left: `deck-bar deck-bar--alert` labeled "One long session" filling (step 1) + tag--error "Forgets what matters" (step 2); right: 4 small cards "Sub-agent 1…4" each with a short green bar (stagger, step 3) + tag--success "Fresh context per task" |
| 6 | Two pillars | `deck-versus`: "Checkpoints" (small pieces of work) and `card--strong` "Gates" (checks the work must pass) slide in (steps 1, 2) |
| 7 | Orchestrator | kicker "One skill to prompt"; `deck-flow` timeline: Prompt → Plan → 🧑 Approve plan → Build + gates → 🧑 Final review → Done; the two human stops are `card--accent` flow items that pop (steps 1–3); lead "You're needed twice." |
| 8 | Checkpoints | `deck-stairs` of 5 cards "1 Smallest" … "5 Most complex" (stagger, step 1); quote line "Catch a wrong decision while it's still cheap" with `mark.hl` (step 2) |
| 9 | Planner + viewer | left: `.code-block` with `data-anim="type"` showing a short JSON checkpoint list (step 1); right: `.deck-window` titled "Checkpoint viewer" with `.deck-screen` list rows + tags Done / In progress / Planned (step 2); caption "JSON for the agent, a page for the human" (step 3) |

- [ ] **Step 1: Write `patterns.css`** with the classes above.
- [ ] **Step 2: Write `presentation/helix-loops/index.html`** (skeleton from `deck/template/index.html`, `<html lang="en">`, `<title>Helix Loops</title>`, links `tokens.css`, `components.css`, `deck/deck.css`, `deck/patterns.css`, scripts in kit order) with scenes 1–9.
- [ ] **Step 3: Verify in Chrome** — serve `/Users/omar.doucoure/Documents/OmApps/design-systems` on a free localhost port (8766 is already running from Task 3; reuse it if it serves that root). For each scene open `#N.<last step>`, reload, wait 2s, screenshot at scale 0.5. Fix: overflow outside stage or card, overlapping text, invisible text (contrast), clipped nodes. Walk forward with ArrowRight from `#1.0` to the end of scene 9 via `KeyboardEvent` dispatch: no console errors.
- [ ] **Step 4: Token check** — `grep -nE '#[0-9A-Fa-f]{3,6}\b|rgba?\(|style=' presentation/helix-loops/index.html deck/patterns.css` → no CSS literals, no inline styles (text content like "#1" is fine).
- [ ] **Step 5: Commit** — design-system-web: `git add deck/patterns.css && git commit -m "Add reusable deck scene patterns"`; design-systems: `git add presentation/helix-loops && git commit -m "Add Helix Loops reproduction scenes 1 to 9"`.

---

### Task 6: Helix Loops reproduction, scenes 10–17

**Files:**
- Modify: `presentation/helix-loops/index.html` (insert before `<div class="deck__progress">`), `design-system-web/deck/patterns.css` (only if a new generic pattern is needed)

**Interfaces:**
- Consumes: Task 5 pattern classes, kit API.

| # | Beat | Content and reveal steps |
|---|---|---|
| 10 | Sub-agents at start | hub "Orchestrator" pops; three nodes grow out via `.deck-link`: "App health check", "Checkpoint planner" (with a bubble "Any questions?" step 2), "Test planner" (step 3) |
| 11 | Gate ≠ rule | `deck-versus`: "Rule" card with caption "Advice. Forgotten mid-task." (step 1, then tag--warn "Ignored" step 2); `card--strong` "Gate" "Blocks the next task until passed" (step 3); terminal `.code-block` typing `stop hook → exit 2 → "not done, keep going"` (step 4) |
| 12 | The 4 gates | `deck-checklist` in a card: Behavior (does it work), UI (does it match the design), Code review (is the code good), Human (does it feel right); each row `data-anim="check" data-done` steps 1–4 |
| 13 | Gate 1 Behavior | `.deck-window` "Tests" with two stacked `.deck-screen` panels: panel A 5 test rows with tag--error "Failing" (step 1); flow line "Code sub-agent writes the feature" (step 2); panel B same rows with tag--success "Passing" fades over (step 3); tag--success "Gate 1 passed" pops (step 4) |
| 14 | Gate 2 UI | `deck-compare`: device "Prototype" and device "App" with near-identical skeleton screens (step 1); two reviewer cards "Looks" and "Behaves" pop between (step 2); combined verdict tag--success "Match · gate passed" (step 3) |
| 15 | Gate 3 Adversarial | `deck-loop`: "Critic agent · assumes the code is wrong" ↔ "Fixer agent · fixes what's found" (steps 1, 2); round counter `count` 0 → 3 labelled "rounds" (step 3); tag--success "Critic approves" pops (step 4) |
| 16 | Gate 4 Human | device mock with checklist of the feature (step 1); bubble "Make the button bigger" (step 2); stagger of result cards "New checkpoint · same gates" and "Saved to learnings file · every agent reads it" (step 3) |
| 17 | Closing | `deck-quote`: "Attempts can be <mark class=hl>wrong</mark>." (step 0) then "Shipping can't." (step 1); caption "Recreated with the HaHo design system" (step 2) |

- [ ] **Step 1: Insert scenes 10–17** following the table; reuse Task 5 patterns; add a generic pattern to `patterns.css` only if none fits.
- [ ] **Step 2: Verify** — same method as Task 5 Step 3 for scenes 10–17, then a full ArrowRight run `#1.0` → end and ArrowLeft back to `#1.0`: no console errors; final hash `#17.2`.
- [ ] **Step 3: Token check** — same grep as Task 5 Step 4.
- [ ] **Step 4: Commit** — `git add presentation/helix-loops/index.html && git commit -m "Add Helix Loops reproduction scenes 10 to 17"` (+ patterns.css commit in design-system-web if changed: "Extend deck scene patterns").

---

### Task 7: Full run-through and checks

- [ ] **Step 1: Keyboard run** — open `#1.0`, press → until the end via javascript_tool, collecting `location.hash` each press. Expected final hash `#17.2`, no console errors (`read_console_messages`).
- [ ] **Step 2: Backward run** — ← to `#1.0`; every scene reached.
- [ ] **Step 3: Token grep** — `grep -nE '#[0-9A-Fa-f]{3,6}\b|rgba?\(|style=' design-system-web/deck/patterns.css presentation/helix-loops/index.html` → no CSS literals, no inline styles.
- [ ] **Step 4: Line limits** — `wc -l design-system-web/deck/*.css design-system-web/deck/*.js` each < 400. `index.html` is scene content (like translation files) and may exceed 400.
- [ ] **Step 5: Offline check** — open `file:///Users/omar.doucoure/Documents/OmApps/design-systems/presentation/helix-loops/index.html` directly; fonts render DM Sans, navigation works.
- [ ] **Step 6: Stop server**, close Chrome tabs.

---

### Task 8: Story-to-deck skill + scene pattern catalog

Goal: a new talk from one prompt ("make a deck: <story>") with zero hand-written CSS and no images.

**Files:**
- Create: `design-system-web/deck/PATTERNS.md`, `design-system-web/deck/new-deck.sh`
- Modify: `design-system-web/README.md` (Deck kit section: one line pointing to `deck/PATTERNS.md` and `new-deck.sh`)
- Create: `~/.claude/skills/motion-deck/SKILL.md` (not in any repo)

**Interfaces:**
- Consumes: kit files (Tasks 1–4), `deck/patterns.css` (Task 5), final `presentation/helix-loops/index.html` and `deck/template/index.html` as snippet sources.
- Produces: `deck/new-deck.sh <dest-dir> "<title>" [lang]` → self-contained folder: `<dest>/index.html` (skeleton, one title scene) + `<dest>/kit/` (copies of `tokens.css`, `components.css`, `fonts/`, `deck/deck.css`, `deck/patterns.css`, `deck/deck-state.js`, `deck/effects.js`, `deck/deck.js`). Talk HTML links `kit/...`. Folder works when zipped or moved anywhere.

- [ ] **Step 1: `deck/new-deck.sh`** (bash, `set -euo pipefail`, no comments): resolve kit dir from script location; fail with usage if dest missing or dest exists and not empty; copy files listed above into `<dest>/kit/` keeping `deck/` subfolder; write `<dest>/index.html` = template head/body skeleton with paths `kit/tokens.css`, `kit/components.css`, `kit/deck/deck.css`, `kit/deck/patterns.css`, scripts `kit/deck/deck-state.js`, `kit/deck/effects.js`, `kit/deck/deck.js`, `<html lang>` = arg 3 (default `fr`), `<title>` = arg 2, one `deck-center` title scene with `<mark class="hl">` title, and the progress bar. Test: `bash deck/new-deck.sh "$SCRATCH/demo" "Demo"` → folder exists, `ls "$SCRATCH/demo/kit/deck"` lists 5 files, opening `$SCRATCH/demo/index.html` over localhost shows title with highlight and `location.hash === "#1.0"`. Second run on same dest → non-zero exit with message.

- [ ] **Step 2: `deck/PATTERNS.md`** — catalog, one section per pattern, each with: **Use when** (story beat it serves), **Steps** (what each click reveals), **Snippet** (complete `<section class="scene">…</section>` copied from the Helix talk or template, content genericized to English placeholders in `[brackets]`). One pattern per distinct Helix scene layout, named by story beat, at least:
  1. `hook-counter` — screen grid + big counter (Helix 1)
  2. `versus` — two cards + highlighted conclusion (Helix 2, 6, 11)
  3. `title-orbit` — kinetic title + orbit hub with up to 7 nodes (Helix 3; list the 7 `deck-node--*` modifiers)
  4. `flow` — step chain revealed left to right (Helix 4, 7)
  5. `context-bar` — filling bar vs small cards (Helix 5)
  6. `stairs` — increasing complexity (Helix 8)
  7. `code-and-window` — typing code block vs app window mock (Helix 9)
  8. `hub-spawn` — hub with spawned nodes and question bubble (Helix 10)
  9. `checklist` — ticking list (Helix 12)
  10. `screen-switch` — window with panels switching states (Helix 13)
  11. `compare` — two devices + reviewers + verdict (Helix 14)
  12. `loop` — two agents back and forth + round counter (Helix 15)
  13. `feedback` — device + bubble + result cards (Helix 16)
  14. `question` — headline → `data-next` button → typing bubble (template scene 1)
  15. `closing-quote` — statement with highlight (Helix 17)
  Top of file: rules (only kit classes, no images, no inline styles, mock screens use `.deck-screen` + DS components + `.deck-skel`, reveal attributes table from README, camera per pattern suggestion). Keep under 400 lines; if longer, keep snippets and shorten prose.

- [ ] **Step 3: Skill `~/.claude/skills/motion-deck/SKILL.md`** — follow `~/.claude/skills-guide.md`. Frontmatter: `name: motion-deck`; description (what + when): builds an animated, click-through HTML presentation from a story using the HaHo design system deck kit; triggers "make a presentation", "deck", "slides", "présentation", "animated presentation like a video", "turn this story into slides"; negative trigger: not for .pptx/Google Slides requests. Body sections:
  - `## Critical`: only kit classes and DS components; zero custom CSS; no images or screenshots, screens are mockups; one idea per scene; ≤ 6 steps per scene; text in the language of the story; no code comments.
  - `## Step 1: Outline` — split story into beats; map each beat to a pattern from `/Users/omar.doucoure/Documents/OmApps/design-systems/design-system-web/deck/PATTERNS.md` (read it first); show the outline as a table (`# | Scene | Pattern | Clicks reveal`) and ask for approval once.
  - `## Step 2: Scaffold` — `bash /Users/omar.doucoure/Documents/OmApps/design-systems/design-system-web/deck/new-deck.sh <dest> "<title>" <lang>`; default dest `~/Documents/Presentations/<slug>`.
  - `## Step 3: Write scenes` — replace the skeleton scene with pattern snippets, filled with the story's content.
  - `## Step 4: Verify` — serve dest with `python3 -m http.server` in background, step through every scene with keydown events in Chrome, screenshot each scene at scale 0.5, fix overflow/contrast, grep for `#hex|rgb|px|style=` in index.html (must be empty except text).
  - `## Step 5: Hand off` — table of scenes + how to present (open `index.html`, → / ← / clicker, F fullscreen, `#scene.step`).
  - `## Examples`: the Helix Loops reproduction (`/Users/omar.doucoure/Documents/OmApps/design-systems/presentation/helix-loops/index.html`) as the reference deck.
  - `## Troubleshooting`: text overflows card → shorten text or split scene; nodes clip in orbit → max 7 nodes, shorter labels; animation doesn't play → element needs `data-anim`/`data-step`, `mark.hl` needs an animated ancestor.

- [ ] **Step 4: Trigger + function test** — in a fresh subagent with no context, give only: "Fais-moi une présentation animée : notre équipe a réduit le temps de build de 20 à 5 minutes. Pourquoi c'était lent, ce qu'on a changé, les résultats, la suite." and let it follow the skill end to end into `$SCRATCH/test-deck`. Expected: outline table, folder built by `new-deck.sh`, ≥ 5 scenes from ≥ 4 different patterns, no custom CSS, navigation works. Fix skill/PATTERNS gaps it hits.

- [ ] **Step 5: Commit** — design-system-web: `git add deck/PATTERNS.md deck/new-deck.sh README.md && git commit -m "Add deck pattern catalog and scaffolding script"`. The skill folder is outside repos; no commit.

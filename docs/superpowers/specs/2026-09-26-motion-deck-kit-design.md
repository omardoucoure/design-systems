# Motion Deck Kit: Design

## Goal

A reusable, click-driven HTML presentation kit built only from the HaHo web design system, with motion-graphics scenes in the style of explainer videos (camera moves, device mockups switching screens, UI cards animating, diagrams drawing in, counters, typewriter). First deck: the Helix Loops reproduction (English), presented live and offline.

## Decisions

| Topic | Decision |
|---|---|
| Engine | Vanilla HTML/CSS/JS, no framework, no build step |
| Output | Live click-driven deck only (no video export) |
| Canvas | DS light style, page background `surfaceNeutral0_5` |
| Language | English |
| Delivery | Local file opened from disk, fully offline (DM Sans bundled, no CDN) |
| Screens | Mockups only: DS components + skeleton bars inside window/phone frames; no screenshots or images |
| Talks | Zero custom CSS; every talk composes reusable layouts from `deck/patterns.css` |

## Architecture

```
design-system-web/                  reusable, ships with the package
├── tokens.css      + motion tokens
├── components.css  existing DS components
└── deck/
    ├── deck.css       stage, scenes, animation classes
    ├── deck.js        navigation, step engine, camera, hash resume
    ├── deck-state.js  pure hash/step state machine
    ├── effects.js     count-up, typewriter, path draw, highlight sweep, chat bubble
    ├── patterns.css   reusable scene layouts (rows, orbit, stairs, bars, bubbles…)
    ├── PATTERNS.md    catalog of scene patterns with markup snippets
    ├── new-deck.sh    scaffolds a new talk folder
    ├── template/      starter scene for a new talk
    └── tests/         deck-state unit tests

design-systems/presentation/helix-loops/   one talk
└── index.html      scenes only, no custom CSS
```

The kit is consumed by relative path from a talk folder. A new talk = new folder with `index.html`, scaffolded by `deck/new-deck.sh` and generated from a story prompt by the `motion-deck` skill using the scene pattern catalog in `deck/PATTERNS.md`.

## Motion tokens (added to `tokens.css`)

| Token | Value |
|---|---|
| `--motion-dur-fast` | 200ms |
| `--motion-dur-base` | 400ms |
| `--motion-dur-slow` | 700ms |
| `--motion-dur-scene` | 900ms |
| `--motion-dur-count` | 1600ms |
| `--motion-dur-typing` | 1200ms |
| `--motion-type-char` | 28ms |
| `--motion-ease-out` | `cubic-bezier(0.22, 1, 0.36, 1)` |
| `--motion-ease-spring` | `cubic-bezier(0.34, 1.56, 0.64, 1)` |
| `--motion-stagger` | 80ms |

Headline sweep uses a new semantic `--surface-highlight` (light: `--s-40`, dark: `--s-100`); no new primitive colors.

## Stage

- Fixed 1280×720 logical stage, scaled with `transform: scale()` to fit the viewport, letterboxed with `surfaceNeutral0_5`.
- One scene visible at a time; the stage acts as camera.
- Body carries `data-brand` and `data-style="lightRounded"`; brand switchable per talk.

## Authoring API

```html
<section class="scene" data-camera="zoom">
  <h1 class="t-display1" data-step="1" data-anim="rise">We are <mark class="hl">AI first</mark></h1>
  <button class="btn btn--filledA btn--big" data-step="2" data-anim="pop" data-next>But…</button>
  <div class="card" data-step="3" data-anim="rise">Are we ready?</div>
</section>
```

| Attribute | Values | Meaning |
|---|---|---|
| `data-step` | integer ≥ 1 | reveal order inside the scene; same number = revealed together; absent = visible on scene entry |
| `data-anim` | `rise`, `fade`, `pop`, `slide-left`, `slide-right`, `grow`, `draw`, `type`, `count`, `bubble`, `check` | entry animation; `mark.hl` sweeps inside any revealed element |
| `data-stagger` | on a container | children reveal one after another using `--motion-stagger` |
| `data-camera` | `fade`, `zoom`, `pan-left`, `pan-up` | scene transition |
| `data-next` | on a button | clicking it advances |
| `data-count-to` | number | target for `count` |

## Navigation

| Input | Effect |
|---|---|
| → / Space / PageDown / click on `data-next` | next step; if none left, next scene |
| ← / PageUp | previous step; if at start, previous scene fully revealed |
| `F` (no modifier held) | toggle fullscreen |
| URL hash `#4.2` | scene 4, step 2; updated on every move; editing the hash directly also navigates |

State machine per scene: `entering → step 0 … step N → leaving`. Going backward removes the last revealed step without replaying earlier ones.

## Effects (`effects.js`)

| Effect | Behavior |
|---|---|
| `count` | animates number from 0 (or `data-count-from`) to `data-count-to` |
| `type` | typewriter on text content, one character per frame tick |
| `draw` | SVG path `stroke-dashoffset` from length to 0 |
| `sweep` | `mark.hl` background grows left to right behind text |
| chat bubble | three-dot typing indicator, then message appears |
| `check` | checkbox ticks after a delay, only when the input exists |

`prefers-reduced-motion: reduce` → all reveals instant, counters jump to target.

## Helix Loops storyline (English)

| # | Scene | Content |
|---|---|---|
| 1 | Hook counter | count-up hook |
| 2 | One prompt vs loop | one prompt compared against the loop |
| 3 | Agent still cheats | the agent still cheats despite the prompt |
| 4 | Title orbit | title card with orbiting nodes |
| 5 | How Helix works | overview of the Helix approach |
| 6 | Fresh context | fresh context per step |
| 7 | Checkpoints vs gates | checkpoints compared against gates |
| 8 | Orchestrator timeline | orchestrator driving a timeline |
| 9 | Checkpoint stairs | checkpoints climbing in complexity |
| 10 | Planner JSON + viewer | plan as JSON next to a checkpoint viewer |
| 11 | Sub-agents at start | sub-agents spun up at the start |
| 12 | Rule vs gate | a rule compared against a gate |
| 13 | The 4 gates | the four gates overview |
| 14 | Gate 1 behavior | behavior gate |
| 15 | Gate 2 design reviewer | design reviewer gate |
| 16 | Gate 2 prototype first | prototype-first pass of the design gate |
| 17 | Gate 2 browser check | browser-check pass of the design gate |
| 18 | Gate 3 adversarial loop | adversarial review loop |
| 19 | Gate 4 human | human gate |
| 20 | Closing | closing scene |

## Rules

- Every color, spacing, radius, font, border and duration comes from `tokens.css`; a missing value becomes a token.
- Only DS component classes for UI; `deck.css` and `deck/patterns.css` define layout and motion only, never one-off component looks.
- Parent/child contrast rule from the DS applies.
- No source file over 400 lines; no code comments.
- Talks carry zero custom CSS and no user-facing strings baked into the engine; all copy lives in the talk's `index.html`.

## Failure modes

| Case | Handling |
|---|---|
| Fonts unavailable | bundled TTF via relative path, system fallback |
| Unknown hash | start at scene 1 |
| Window resize | stage rescales |

## Verification

- Open `presentation/helix-loops/index.html` in Chrome from disk, step through every scene forward and backward, screenshot each scene.
- Token self-check grep returns no raw hex or px literals in the talk file.

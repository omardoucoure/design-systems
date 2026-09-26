# Motion Deck Kit — Design

## Goal

A reusable, click-driven HTML presentation kit built only from the HaHo web design system, with motion-graphics scenes in the style of explainer videos (camera moves, device mockups switching screens, UI cards animating, diagrams drawing in, counters, typewriter). First deck: PFU Studio talk (French), presented live and offline.

## Decisions

| Topic | Decision |
|---|---|
| Engine | Vanilla HTML/CSS/JS, no framework, no build step |
| Output | Live click-driven deck only (no video export) |
| Canvas | DS light style, page background `surfaceNeutral0_5` |
| Language | PFU Studio deck in French |
| Delivery | Local file opened from disk, fully offline (DM Sans bundled, no CDN) |
| Media | User supplies PFU Studio screenshots / screen recording in `assets/`; placeholders until then |
| Visual reference | AI LABS video `bBMp5tLxShQ`: single stage, camera pan/zoom, staggered UI reveals, orbit diagram, count-up, kinetic headline with highlight box |

## Architecture

```
design-system-web/                  reusable, ships with the package
├── tokens.css      + motion tokens
├── components.css  existing DS components
└── deck/
    ├── deck.css    stage, scenes, animation classes
    ├── deck.js     navigation, step engine, camera, hash resume
    └── effects.js  count-up, typewriter, path draw, highlight sweep, chat bubble

design-systems/presentation/pfu-studio/   one talk
├── index.html      scenes only
└── assets/         screenshots, recordings
```

The kit is consumed by relative path from a talk folder. A new talk = new folder with `index.html` + `assets/`.

## Motion tokens (added to `tokens.css`)

| Token | Value |
|---|---|
| `--motion-dur-fast` | 200ms |
| `--motion-dur-base` | 400ms |
| `--motion-dur-slow` | 700ms |
| `--motion-dur-scene` | 900ms |
| `--motion-ease-out` | `cubic-bezier(0.22, 1, 0.36, 1)` |
| `--motion-ease-spring` | `cubic-bezier(0.34, 1.56, 0.64, 1)` |
| `--motion-stagger` | 80ms |

A highlight color for the headline sweep uses an existing surface token (`surfaceSecondary40`); no new color tokens.

## Stage

- Fixed 1920×1080 logical stage, scaled with `transform: scale()` to fit the viewport, letterboxed with `surfaceNeutral0_5`.
- One scene visible at a time; the stage acts as camera.
- Body carries `data-brand` and `data-style="lightRounded"`; brand switchable per talk.

## Authoring API

```html
<section class="scene" data-camera="zoom">
  <h1 class="t-display1" data-step="1" data-anim="rise">On est <mark class="hl">AI first</mark></h1>
  <button class="btn btn--filled btn--big" data-step="2" data-anim="pop" data-next>Mais…</button>
  <div class="card" data-step="3" data-anim="rise">Sommes-nous prêts ?</div>
</section>
```

| Attribute | Values | Meaning |
|---|---|---|
| `data-step` | integer ≥ 1 | reveal order inside the scene; same number = revealed together; absent = visible on scene entry |
| `data-anim` | `rise`, `fade`, `pop`, `slide-left`, `slide-right`, `draw`, `type`, `count`, `sweep` | entry animation |
| `data-stagger` | on a container | children reveal one after another using `--motion-stagger` |
| `data-camera` | `fade`, `zoom`, `pan-left`, `pan-up` | scene transition |
| `data-next` | on a button | clicking it advances |
| `data-count-to` | number | target for `count` |

## Navigation

| Input | Effect |
|---|---|
| → / Space / PageDown / click on `data-next` | next step; if none left, next scene |
| ← / PageUp | previous step; if at start, previous scene fully revealed |
| `F` | toggle fullscreen |
| URL hash `#4.2` | scene 4, step 2; updated on every move |

State machine per scene: `entering → step 0 … step N → leaving`. Going backward removes the last revealed step without replaying earlier ones.

## Effects (`effects.js`)

| Effect | Behavior |
|---|---|
| `count` | animates number from 0 (or `data-count-from`) to `data-count-to` |
| `type` | typewriter on text content, one character per frame tick |
| `draw` | SVG path `stroke-dashoffset` from length to 0 |
| `sweep` | `mark.hl` background grows left to right behind text |
| chat bubble | three-dot typing indicator, then message appears |

`prefers-reduced-motion: reduce` → all reveals instant, counters jump to target.

## PFU Studio storyline (French)

| # | Scene | Content | Motion |
|---|---|---|---|
| 1 | Titre | PFU Studio, subtitle, Mac window mock with screenshot | highlight sweep, window rises |
| 2 | Pourquoi | Mobile team isolated (compilation, simulateur, environnement) vs QA, Design, Produit | islands appear, connectors draw, PFU Studio lands in center |
| 3 | AI first | "On est AI first" → button → "Mais… sommes-nous prêts ?" as a chat bubble from a person | kinetic type, pop, typing bubble |
| 4 | Paradoxe | PRs 12 → 140; QA queue overflowing; human review ring in red; questions: QA prête ? revue humaine ? qualité ? workflow ? | count-up, list overflow, progress ring |
| 5 | Slogan vs capacité | AI first = slogan, AI ready = capacité | split cards, highlight |
| 6 | Le cœur | PFU Studio at center; orbit: agents (Kim, Cody, Arthur), Maestro, simulateur, Jira, verdicts | orbit draws in, nodes pop |
| 7 | Démo | device + Mac frames with user media, screen switching | slide in, crossfade |
| 8 | Prochaines étapes | roadmap checklist | checkboxes tick staggered |
| 9 | Merci | questions | fade |

## Rules

- Every color, spacing, radius, font, border and duration comes from `tokens.css`; a missing value becomes a token.
- Only DS component classes for UI; `deck.css` defines layout and motion only.
- Parent/child contrast rule from the DS applies.
- No source file over 400 lines; no code comments.
- Text in the talk file is plain French content; engine has no user-facing strings.

## Failure modes

| Case | Handling |
|---|---|
| Missing media file | placeholder card with file name shown |
| Fonts unavailable | bundled TTF via relative path, system fallback |
| Unknown hash | start at scene 1 |
| Window resize | stage rescales |

## Verification

- Open `presentation/pfu-studio/index.html` in Chrome from disk, step through every scene forward and backward, screenshot each scene.
- Token self-check grep returns no raw hex or px literals in the talk file.

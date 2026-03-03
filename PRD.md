# PRD — Enum-Driven Mobile Design System

**Project:** HaHo-Inspired Multi-Brand Design System
**Platforms:** iOS (SwiftUI) + Android (Jetpack Compose)
**Date:** 2026-03-03
**Status:** Draft

---

## 1. Vision

Build a **fully tokenized, enum-driven design system** for native mobile (iOS + Android) where switching **two enum values** transforms the entire UI identity — colors, radius, typography, spacing, elevation, and component styles — without touching any component code.

The system uses a **2-axis architecture**:
- **Brand axis** (`Brand` enum): Controls the color palette — `.coralCamo`, `.seaLime`, `.mistyRose`, `.blueHaze`
- **Style axis** (`Style` enum): Controls color mode + shape — `.lightRounded`, `.darkRounded`, `.lightSharp`, `.darkSharp`

This creates **16 possible combinations** (4 brands × 4 styles). Adding a new brand = adding a new enum case + a primitive color palette. Adding a new style = adding a new mode mapping. Zero component modifications required.

The system is designed for **AI-assisted development**: specify a `Brand` and `Style` and every component adapts automatically.

---

## 2. Core Principles

| Principle | Description |
|-----------|-------------|
| **Dual-enum-driven** | Two enums (`Brand` + `Style`) compose the full visual identity. Brand × Style = 16 combinations |
| **Zero hardcoded values** | Every visual property (color, radius, spacing, font, shadow) reads from token objects — never from literals |
| **Token-first** | 3-tier token hierarchy: Primitive → Semantic → Component |
| **Platform-native** | SwiftUI + Compose, no cross-platform abstraction layer. Each platform feels native |
| **Multi-brand ready** | Adding a brand = adding a `Brand` enum case + primitive palette. Components never change |
| **AI-friendly** | Simple, predictable API surface. An AI specifies `Brand` + `Style` and generates a full app |
| **Distributable** | Published as a Swift Package (SPM) and Gradle/Maven artifact. Consumers add one dependency line |

---

## 3. Architecture Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                         App Layer                                │
│   ContentView / MainActivity                                     │
│   .designSystem(brand: .coralCamo, style: .lightRounded)         │
├──────────────────────────────────────────────────────────────────┤
│                      Theme Provider                              │
│   Resolves Brand + Style → ThemeConfiguration                    │
│   Injects via @Environment / CompositionLocal                    │
├──────────────────────────────────────────────────────────────────┤
│                       Components                                 │
│   DSTextField, DSDropdown, DSButton, DSDatePicker...             │
│   Read ALL values from theme. Zero hardcoded styles.             │
├──────────────────────────────────────────────────────────────────┤
│               Semantic Token Data Objects                         │
│   ColorTokens, TypographyTokens, SpacingTokens,                 │
│   RadiusTokens, BorderTokens, ElevationTokens,                  │
│   AnimationTokens, OpacityTokens                                 │
│   (Resolved from Style enum: light/dark × rounded/sharp)         │
├──────────────────────────────────────────────────────────────────┤
│                   Primitive Values                                │
│   Brand colors, Neutrals, Semantic colors,                       │
│   Spacing scale, Radius scale, Border widths,                    │
│   Opacity levels, Drop shadows                                   │
│   (Resolved from Brand enum: coralCamo/seaLime/mistyRose/...)    │
├──────────────────────────────────────────────────────────────────┤
│                    Two-Axis Enums                                 │
│   Brand: .coralCamo  .seaLime  .mistyRose  .blueHaze            │
│   Style: .lightRounded  .darkRounded  .lightSharp  .darkSharp   │
│   Brand selects primitive palette, Style selects token mapping   │
└──────────────────────────────────────────────────────────────────┘
```

---

## 4. Token System (Extracted from HaHo Figma)

Source: Figma file `4kcXyu53LWpUMVyhPvA4hY`, variable set `2-5334`.
Full data: `tokens/primitives.json` (82 variables × 4 brands) + `tokens/tokens.json` (51 variables × 4 modes).

### 4.1 Two-Axis Enum System

The design system uses **two independent enums** that compose together:

```
Brand (selects primitive color palette)
  ├── .coralCamo     ← Warm earth tones (green-brown primary, coral secondary)
  ├── .seaLime       ← Cool blue primary, lime-green secondary
  ├── .mistyRose     ← Muted slate primary, pink secondary
  └── .blueHaze      ← Vivid blue primary, warm beige secondary

Style (selects token mapping: color mode + shape)
  ├── .lightRounded  ← Light mode + rounded corners (default)
  ├── .darkRounded   ← Dark mode (inverted neutrals, swapped primary↔secondary) + rounded corners
  ├── .lightSharp    ← Light mode + all radius → 0 (except full)
  └── .darkSharp     ← Dark mode + all radius → 0 (except full)
```

**Composition:** `Brand × Style = ThemeConfiguration`
- Brand resolves **primitives** (what the raw hex values are)
- Style resolves **tokens** (how primitives map to semantic roles)

### 4.2 Primitives — Brand Colors (per Brand enum)

Each brand defines 7 brand color steps:

| Primitive | Coral Camo | Sea Lime | Misty Rose | Blue Haze |
|---|---|---|---|---|
| `brand.primary80` | `#657671` | `#5370A1` | `#5E6B80` | `#4A5FD5` |
| `brand.primary100` | `#465A54` | `#3B588A` | `#4C5A6F` | `#2742DA` |
| `brand.primary120` | `#252F2C` | `#1B2940` | `#262D37` | `#21253D` |
| `brand.secondary10` | `#FFF3F2` | `#FAFEF2` | `#FFF5FB` | `#FCFAF8` |
| `brand.secondary40` | `#FFC3BF` | `#E5FBBF` | `#FED6EF` | `#F4EAE3` |
| `brand.secondary100` | `#FF6A5F` | `#B1E158` | `#EA81C2` | `#D6B7A1` |
| `brand.secondary120` | `#EB5B52` | `#A0D342` | `#DC70B3` | `#CCA78F` |

### 4.3 Primitives — Neutral Scale (per Brand enum)

Each brand defines a 15-step neutral scale with unique undertone:

| Step | Coral Camo | Sea Lime | Misty Rose | Blue Haze |
|---|---|---|---|---|
| `0` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` |
| `0.5` | `#FAFAF9` | `#FAFAFA` | `#F9F9FA` | `#F9F8F8` |
| `1` | `#F5F5F3` | `#F5F6F4` | `#F4F4F5` | `#F3F1F1` |
| `1.5` | `#F0F0EC` | `#F0F1EF` | `#EEEEF1` | `#EDEBE9` |
| `2` | `#EBEBE6` | `#EBEDE9` | `#E9E8EC` | `#E7E4E2` |
| `3` | `#E2E1DA` | `#E1E3DF` | `#DDDDE2` | `#DBD6D4` |
| `4` | `#D8D7CD` | `#D7DAD5` | `#D2D1D9` | `#CFC9C5` |
| `5` | `#CECDC1` | `#CDD1CA` | `#C7C6CF` | `#C3BBB7` |
| `6` | `#A5A49A` | `#A4A8A2` | `#9F9EA6` | `#9C9692` |
| `7` | `#7C7B74` | `#7B7E7A` | `#77777C` | `#75706E` |
| `8` | `#52524D` | `#535551` | `#504F53` | `#4E4B49` |
| `8.5` | `#3E3E3A` | `#3E403D` | `#3C3B3E` | `#3B3837` |
| `9` | `#292927` | `#2A2B29` | `#282829` | `#272525` |
| `9.5` | `#151513` | `#151715` | `#141415` | `#141312` |
| `10` | `#000000` | `#000000` | `#000000` | `#000000` |

### 4.4 Primitives — Semantic Colors (shared across all brands)

| Token | Value |
|---|---|
| `semantic.error` | `#FF6565` |
| `semantic.warning` | `#FFD143` |
| `semantic.validated` | `#76F057` |
| `semantic.infoFocus` | `#53D5FF` |

### 4.5 Primitives — Spacing (shared across all brands and styles)

| Token | Value (px) |
|---|---|
| `spacing.none` | 0 |
| `spacing.xxxs` | 2 |
| `spacing.xxs` | 4 |
| `spacing.xs` | 8 |
| `spacing.sm` | 12 |
| `spacing.md` | 16 |
| `spacing.lg` | 24 |
| `spacing.xl` | 32 |
| `spacing.xxl` | 40 |
| `spacing.xxxl` | 48 |
| `spacing.xxxxl` | 64 |

### 4.6 Primitives — Radius (shared across all brands)

| Token | Value (px) |
|---|---|
| `radius.none` | 0 |
| `radius.xxs` | 4 |
| `radius.xs` | 8 |
| `radius.sm` | 12 |
| `radius.md` | 16 |
| `radius.lg` | 24 |
| `radius.xl` | 32 |
| `radius.xxl` | 40 |
| `radius.xxxl` | 64 |
| `radius.full` | 360 |

### 4.7 Primitives — Border Width, Opacity, Drop Shadow

**Border Width:**

| Token | Value (px) |
|---|---|
| `borderWidth.none` | 0 |
| `borderWidth.sm` | 1 |
| `borderWidth.md` | 2 |
| `borderWidth.lg` | 4 |

**Opacity:**

| Token | Value (%) |
|---|---|
| `opacity.none` | 0 |
| `opacity.sm` | 25 |
| `opacity.md` | 50 |
| `opacity.lg` | 75 |
| `opacity.full` | 100 |

**Drop Shadow — Positioning:**

| Token | Value (px) |
|---|---|
| `none` | 0 | `xxxs` | 2 | `xxs` | 4 | `xs` | 8 | `sm` | 12 | `md` | 16 | `lg` | 20 | `xl` | 24 | `xxl` | 32 | `xxxl` | 48 |

**Drop Shadow — Blur:** none=0, xxs=2, xs=4, sm=8, md=16, lg=24, xl=48, xxl=64

**Drop Shadow — Spread:** none=0, xxs=-2, xs=-4, sm=-8, md=-12, lg=-16, xl=-20, xxl=-24

### 4.8 Semantic Tokens — How Style Enum Maps Primitives to Roles

The Style enum resolves which primitive values are used for each semantic role. This is the **core of the 2-axis system**.

#### 4.8.1 Surface Tokens (7 tokens)

| Semantic Token | Light (Rounded/Sharp) | Dark (Rounded/Sharp) | Behavior |
|---|---|---|---|
| `surfaceNeutral0_5` | `neutrals.0.5` | `neutrals.9` | Inverts |
| `surfaceNeutral2` | `neutrals.2` | `neutrals.8.5` | Inverts |
| `surfaceNeutral3` | `neutrals.3` | `neutrals.8` | Inverts |
| `surfaceNeutral9` | `neutrals.9` | `neutrals.0.5` | Inverts |
| `surfacePrimary100` | `brand.primary100` | `brand.secondary100` | **Swaps** |
| `surfacePrimary120` | `brand.primary120` | `neutrals.5` | Shifts |
| `surfaceSecondary100` | `brand.secondary100` | `brand.primary100` | **Swaps** |

**Key insight:** In dark mode, primary and secondary colors **swap roles**, and the neutral scale **inverts** (light neutrals become dark, dark become light).

#### 4.8.2 Text Tokens (9 tokens)

| Semantic Token | Light | Dark | Note |
|---|---|---|---|
| `textNeutral9` | `neutrals.9` | `neutrals.3` | Inverts |
| `textNeutral8` | `neutrals.8` | `neutrals.2` | Inverts |
| `textNeutral3` | `neutrals.3` | `neutrals.8` | Inverts |
| `textNeutral2` | `neutrals.2` | `neutrals.8.5` | Inverts |
| `textNeutral0_5` | `neutrals.0.5` | `neutrals.9` | Inverts |
| `textPrimary100` | `brand.primary100` | `brand.secondary100` | Swaps |
| `textSecondary100` | `brand.secondary100` | `brand.primary100` | Swaps |
| `textOpacity75` | `opacity.lg` (75%) | `opacity.lg` (75%) | Same |
| `textOpacity50` | `opacity.md` (50%) | `opacity.md` (50%) | Same |

#### 4.8.3 Border Tokens (13 tokens)

| Semantic Token | Light | Dark | Note |
|---|---|---|---|
| `borderNeutral9_5` | `neutrals.9` | `neutrals.3` | Inverts |
| `borderNeutral8` | `neutrals.8` | `neutrals.2` | Inverts |
| `borderNeutral3` | `neutrals.3` | `neutrals.8` | Inverts |
| `borderNeutral2` | `neutrals.2` | `neutrals.8.5` | Inverts |
| `borderNeutral0_5` | `neutrals.0.5` | `neutrals.9` | Inverts |
| `borderSecondary100` | `brand.secondary100` | `brand.secondary100` | Same (all modes) |
| `borderPrimary100` | `brand.primary100` | `brand.primary100` | Same (all modes) |
| `borderWidthNone` | 0 | 0 | Same |
| `borderWidthSm` | 1 | 1 | Same |
| `borderWidthMd` | 2 | 2 | Same |
| `borderWidthLg` | 4 | 4 | Same |
| `borderOpacity75` | 75% | 75% | Same |
| `borderOpacity50` | 50% | 50% | Same |

#### 4.8.4 Radius Tokens — The Shape Axis (10 tokens)

**This is the key shape differentiator.** Sharp modes reset ALL radius to 0 except `full`.

| Semantic Token | Rounded (Light/Dark) | Sharp (Light/Dark) |
|---|---|---|
| `radiusNone` | `radius.none` (0) | `radius.none` (0) |
| `radiusXxs` | `radius.xxs` (4) | **0** |
| `radiusXs` | `radius.xs` (8) | **0** |
| `radiusSm` | `radius.sm` (12) | **0** |
| `radiusMd` | `radius.md` (16) | **0** |
| `radiusLg` | `radius.lg` (24) | **0** |
| `radiusXl` | `radius.xl` (32) | **0** |
| `radiusXxl` | `radius.xxl` (40) | **0** |
| `radiusXxxl` | `radius.xxxl` (64) | **0** |
| `radiusFull` | `radius.full` (360) | `radius.full` (360) |

#### 4.8.5 Spacing Tokens (11 tokens — pass-through)

Spacing is **identical across all 4 modes**. No mapping needed — direct pass-through from primitives.

#### 4.8.6 Boolean Token

| Token | Light modes | Dark modes |
|---|---|---|
| `boolean` | `true` | `false` |

Used for conditional rendering (e.g., show/hide elements based on color mode).

### 4.9 Typography Tokens

Font family: **DM Sans** (HaHo default, shared across all brands)

| Token | Size | Weight | Line Height | Letter Spacing | Usage |
|---|---|---|---|---|---|
| `typography.display1` | 56 | 500 (Medium) | 1.2 | -5.0% | Hero display text |
| `typography.h1` | 40 | 500 (Medium) | 1.2 | -4.5% | Page titles |
| `typography.h3` | 32 | 500 (Medium) | 1.2 | -4.5% | Section titles, date picker heading |
| `typography.largeSemiBold` | 18 | 600 (SemiBold) | 1.5 | -3.5% | Emphasized large body |
| `typography.largeRegular` | 18 | 400 (Regular) | 1.5 | -3.5% | Large body text |
| `typography.bodySemiBold` | 16 | 600 (SemiBold) | 1.5 | -2.5% | Textarea title, bold body |
| `typography.body` | 16 | 500 (Medium) | 1.5 | -2.5% | Input text, dropdown items |
| `typography.bodyRegular` | 16 | 400 (Regular) | 1.5 | -2.5% | Textarea content, body text |
| `typography.label` | 14 | 600 (SemiBold) | 1.5 | -2.5% | Button labels |
| `typography.caption` | 14 | 500 (Medium) | 1.5 | -2.5% | Helper text, sub-labels |
| `typography.small` | 12 | 500 (Medium) | 1.5 | -2.0% | Floating label (active/filled) |

### 4.10 Elevation Tokens

Composed from drop shadow primitives:

| Token | Value | Usage |
|---|---|---|
| `elevation.none` | no shadow | Default state |
| `elevation.sm` | `0 4px 8px -2px rgba(0,0,0,0.1), 0 2px 2px -2px rgba(0,0,0,0.06)` | Dropdown menu |

---

## 5. Component Inventory (Phase 1 — Forms & Inputs)

All components extracted from the HaHo Figma node `125-1453`.

### 5.1 DSTextField

The core input component. Two visual variants, seven states.

**Variants (enum-driven):**

| Variant | Description | Key Visual Difference |
|---|---|---|
| `InputVariant.filled` | Filled background with border | `surface.neutral2` background, rounded on all sides |
| `InputVariant.lined` | Bottom-border only | Transparent background, only bottom border |

**States (enum-driven):**

| State | Border Color | Text Opacity | Helper Text Color | Background |
|---|---|---|---|---|
| `.empty` | `border.neutral2` (filled) / `border.neutral9_5` (lined) | 0.5 | neutral9 @ 0.5 | `surface.neutral2` / transparent |
| `.filled` | `border.neutral2` / `border.neutral9_5` | 1.0 | neutral9 @ 0.5 | `surface.neutral2` / transparent |
| `.active` | `semantic.infoFocus` (#53D5FF) | 1.0 | neutral9 @ 0.5 | `surface.neutral0_5` / transparent |
| `.error` | `semantic.error` (#FF6565) | 1.0 | `semantic.error` | `surface.neutral2` / transparent |
| `.validated` | `semantic.validated` (#76F057) | 1.0 | neutral9 @ 0.5 | `surface.neutral2` / transparent |

**Configurable Properties:**

| Property | Type | Default |
|---|---|---|
| `variant` | `InputVariant` | `.filled` |
| `state` | `InputState` | `.empty` |
| `placeholder` | `LocalizedStringKey` | required |
| `label` | `LocalizedStringKey?` | nil (shows when `.filled`/`.active`) |
| `helperText` | `LocalizedStringKey?` | nil |
| `iconLeft` | `DSIcon?` | nil |
| `iconRight` | `DSIcon?` | nil |
| `showActionButton` | `Bool` | false |
| `text` | `Binding<String>` | required |

**Layout Specs (from Figma):**

- Height: 56px
- Internal padding: `spacing.md` (16) all sides
- Icon size: 24x24
- Icon-to-text gap: 12
- Action button: 32px height, pill shape, `surface.secondary100` bg
- Helper text: `spacing.xxs` (4) below input, `spacing.md` (16) left padding
- Label (when visible): `typography.small` (12px), 0.75 opacity

### 5.2 DSDropdown

Dropdown menu that extends from a `DSTextField`.

**Structure:**
- Trigger: `DSTextField` in dropdown mode (with chevron icon)
- Menu: Rounded container with shadow (`elevation.sm`)
- Items: Top / Middle / Middle-Selected / Middle-Pressed / Bottom

**Item States:**

| State | Text Opacity | Background | Extra |
|---|---|---|---|
| Default | 0.5 | transparent | — |
| Selected | 1.0 | transparent | Checkmark icon |
| Pressed | 1.0 | `surface.neutral0_5` | `radius.xxl` (40) rounded bg |

**Layout Specs:**
- Container: `radius.lg` (16) rounded, `elevation.sm` shadow
- Item padding: `spacing.md` (16)
- Pressed item: nested with `spacing.md` horizontal padding, `radius.xxl` inner bg

### 5.3 DSTextArea

Multi-line text input.

**Layout Specs:**
- Container: `surface.neutral2` background, `radius.lg` (16) rounded
- Padding: `spacing.md` (16) all sides
- Title: `typography.bodyLarge` (16px, SemiBold)
- Content: `typography.bodyRegular` (16px, Regular), `opacity.high` (0.75)
- Resize handle: bottom-right corner

### 5.4 DSDatePicker

Date picker with single and range modes.

**Variants:**

| Variant | Description |
|---|---|
| `.single` | One date input field |
| `.range` | Two date input fields side by side |

**Structure:**
- Container: `surface.neutral2`, `radius.xl` (28) rounded
- Header: title ("Select date") + large date display + calendar icon button
- Input area: `DSTextField` in `.active` state
- Actions: Cancel (text button) + Ok (pill button, `surface.primary120`)

### 5.5 DSButton (Supporting Component)

Extracted from input action buttons and date picker actions.

**Variants:**

| Variant | Background | Text Color | Shape |
|---|---|---|---|
| `.primary` | `surface.primary120` (#252F2C) | `text.neutral0_5` | Pill (`radius.full`) |
| `.secondary` | `surface.secondary100` (#FF6A5F) | white | Pill (`radius.full`) |
| `.ghost` | transparent | `text.neutral9` | None |
| `.icon` | `surface.neutral2` | — | Circle/Pill |

---

## 6. Enum-Driven Architecture (Detail)

### 6.1 Two-Axis Resolution Flow

```
Brand.coralCamo + Style.lightRounded
    ↓ Brand resolves primitives
Primitives(
    primary100: #465A54,          ← from coralCamo palette
    secondary100: #FF6A5F,
    neutrals: [#FAFAF9 ... #000000],  ← warm undertone scale
    spacing: [0, 2, 4, 8, 12, 16, 24, 32, 40, 48, 64],
    radius: [0, 4, 8, 12, 16, 24, 32, 40, 64, 360],
    ...
)
    ↓ Style maps primitives → semantic tokens
ThemeConfiguration(
    colors: ColorTokens(
        surfaceNeutral0_5: primitives.neutrals[0.5],    ← lightRounded: use light end
        surfaceNeutral2:   primitives.neutrals[2],
        surfacePrimary100: primitives.primary100,         ← lightRounded: keep as-is
        surfaceSecondary100: primitives.secondary100,
        textNeutral9:      primitives.neutrals[9],
        ...
    ),
    radius: RadiusTokens(
        xxs: primitives.radius.xxs,   ← rounded: pass-through (4px)
        sm:  primitives.radius.sm,     ← rounded: pass-through (12px)
        md:  primitives.radius.md,     ← rounded: pass-through (16px)
        full: primitives.radius.full,  ← always pass-through (360px)
        ...
    ),
    spacing: SpacingTokens(...),       ← always pass-through
    typography: TypographyTokens(...), ← shared across all combos
    ...
)
```

**Same Brand, different Style:**

```
Brand.coralCamo + Style.darkSharp
    ↓ Brand resolves SAME primitives (coralCamo palette)
    ↓ Style maps DIFFERENTLY:
ThemeConfiguration(
    colors: ColorTokens(
        surfaceNeutral0_5: primitives.neutrals[9],       ← dark: INVERTED
        surfaceNeutral2:   primitives.neutrals[8.5],     ← dark: INVERTED
        surfacePrimary100: primitives.secondary100,       ← dark: PRIMARY↔SECONDARY SWAPPED
        surfaceSecondary100: primitives.primary100,       ← dark: SWAPPED
        textNeutral9:      primitives.neutrals[3],        ← dark: INVERTED
        ...
    ),
    radius: RadiusTokens(
        xxs: 0,     ← sharp: ALL radius reset to 0
        sm:  0,     ← sharp: ALL radius reset to 0
        md:  0,     ← sharp: ALL radius reset to 0
        full: 360,  ← sharp: EXCEPT full (always 360)
        ...
    ),
    ...
)
```

### 6.2 Adding a New Brand

To add a 5th brand:

```swift
// Step 1: Add brand enum case
enum Brand {
    case coralCamo, seaLime, mistyRose, blueHaze
    case neoBank   // ← new
}

// Step 2: Define its primitive palette
extension Brand {
    var primitives: BrandPrimitives {
        switch self {
        // ... existing cases ...
        case .neoBank: return BrandPrimitives(
            primary80:     Color(hex: "#5B8DEF"),
            primary100:    Color(hex: "#0D6EFD"),
            primary120:    Color(hex: "#0A58CA"),
            secondary10:   Color(hex: "#F8F0FF"),
            secondary40:   Color(hex: "#D0AAFF"),
            secondary100:  Color(hex: "#6610F2"),
            secondary120:  Color(hex: "#520DC2"),
            neutrals: NeutralScale(...)  // 15-step scale with cool undertone
        )
        }
    }
}

// Step 3: Done. All 4 styles work automatically with the new brand.
// lightRounded, darkRounded, lightSharp, darkSharp all resolve correctly.
```

### 6.3 Adding a New Style

To add a 5th style mode:

```swift
// Step 1: Add style enum case
enum Style {
    case lightRounded, darkRounded, lightSharp, darkSharp
    case lightPlayful   // ← new (light mode + extra-rounded)
}

// Step 2: Define its token mapping
extension Style {
    func resolve(from primitives: BrandPrimitives) -> SemanticTokens {
        switch self {
        // ... existing cases ...
        case .lightPlayful: return SemanticTokens(
            surfaceNeutral0_5: primitives.neutrals[0.5],   // light
            surfacePrimary100: primitives.primary100,        // no swap
            radiusXxs: primitives.radius.sm,                 // upscaled radius!
            radiusSm:  primitives.radius.lg,                 // upscaled!
            radiusMd:  primitives.radius.xl,                 // upscaled!
            radiusFull: primitives.radius.full,              // always 360
            ...
        )
        }
    }
}

// Step 3: Done. All brands work with the new style.
```

### 6.4 What Each Axis Controls

| Axis | Controls | Example |
|---|---|---|
| **Brand** | Primary color palette (7 steps) | `#465A54` → `#2742DA` |
| **Brand** | Secondary color palette (7 steps) | `#FF6A5F` → `#D6B7A1` |
| **Brand** | Neutral scale undertone (15 steps) | Warm beige → Cool slate |
| **Style** | Light/Dark color inversion | Neutral 0.5 ↔ Neutral 9 |
| **Style** | Primary ↔ Secondary swap | Primary becomes secondary in dark |
| **Style** | Rounded/Sharp corner behavior | 16px → 0px (except pill shapes) |

**Spacing, typography, border widths, opacity, and elevation are shared** across all brands and styles.

---

## 7. Implementation Phases

### Phase 1 — Foundation (Tokens + Theme Engine)

**Scope:** Token data objects, enum, theme provider, injection mechanism.

| Task | Platform | Description |
|---|---|---|
| 1.1 | Shared | Token JSON source files already created (`tokens/primitives.json`, `tokens/tokens.json`) |
| 1.2 | iOS | Scaffold SPM package (`Package.swift`, folder structure, bundled fonts) |
| 1.3 | iOS | Create Swift primitive structs: `BrandPrimitives` (brand colors + neutrals), `SharedPrimitives` (spacing, radius, borderWidth, opacity, dropShadow, semantic colors) |
| 1.4 | iOS | Create Swift semantic token structs: `ColorTokens`, `RadiusTokens`, `SpacingTokens`, `BorderTokens`, `OpacityTokens`, `ElevationTokens`, `TypographyTokens`, `AnimationTokens` |
| 1.5 | iOS | Create `Brand` enum (4 cases → resolves to `BrandPrimitives`) + `Style` enum (4 cases → maps primitives to semantic tokens) + `ThemeConfiguration` struct |
| 1.6 | iOS | Create `ThemeProvider` using `@Environment` injection. Consumer calls `.designSystem(brand: .coralCamo, style: .lightRounded)` |
| 1.7 | Android | Scaffold Gradle library module (`build.gradle.kts`, maven-publish plugin, folder structure, bundled fonts) |
| 1.8 | Android | Create Kotlin primitive data classes (same structure as iOS) |
| 1.9 | Android | Create Kotlin semantic token data classes |
| 1.10 | Android | Create `Brand` enum + `Style` enum + `ThemeConfiguration` data class |
| 1.11 | Android | Create `ThemeProvider` using `CompositionLocal` injection |

**Acceptance Criteria:**
- [ ] Changing `Brand` at app root switches the entire color palette
- [ ] Changing `Style` at app root switches light/dark and rounded/sharp
- [ ] All 16 combinations (4 brands × 4 styles) resolve correctly
- [ ] Dark mode: neutrals invert and primary↔secondary swap
- [ ] Sharp mode: all radius → 0 except `full` (360)
- [ ] All tokens accessible via `theme.colors.surfaceNeutral2`, `theme.spacing.md`, etc.

### Phase 2 — Core Components (Forms & Inputs)

**Scope:** Implement the 5 components from the HaHo Figma.

| Task | Component | Description |
|---|---|---|
| 2.1 | `DSTextField` | Both variants (filled/lined), all 5 states, all configurable props |
| 2.2 | `DSDropdown` | Menu with items (default, selected, pressed), extends DSTextField |
| 2.3 | `DSTextArea` | Multi-line with title, resize handle |
| 2.4 | `DSDatePicker` | Single + range modes, integrates DSTextField |
| 2.5 | `DSButton` | Primary, secondary, ghost, icon variants |

**Per component, implement on both iOS and Android.**

**Acceptance Criteria:**
- [ ] Visual parity with HaHo Figma screenshots
- [ ] Zero hardcoded values — every visual reads from `theme.*`
- [ ] Switching `DesignSystemStyle` transforms all components
- [ ] All text uses `LocalizedStringKey` (iOS) / string resources (Android)

### Phase 3 — Multi-Brand & Multi-Style Proof

**Scope:** Demonstrate all 4 brands × 4 styles (16 combinations) with zero component changes.

| Task | Description |
|---|---|
| 3.1 | Implement all 4 Brand primitives (coralCamo, seaLime, mistyRose, blueHaze) |
| 3.2 | Verify all 4 Style mappings (lightRounded, darkRounded, lightSharp, darkSharp) |
| 3.3 | Generate 16-combination matrix screenshot grid (brand × style) |
| 3.4 | Validate dark mode inversion: neutrals invert, primary↔secondary swap |
| 3.5 | Validate sharp mode: all radius → 0 except full (360) |

**Acceptance Criteria:**
- [ ] All 5 components render correctly in all 16 combinations
- [ ] Zero component code was modified — only Brand/Style enum values change
- [ ] Side-by-side 4×4 comparison grid for each component
- [ ] Color contrast meets WCAG AA in all 16 combinations

### Phase 4 — Testing & Documentation

| Task | Description |
|---|---|
| 4.1 | Snapshot tests: each component × each brand × each style (5 components × 4 brands × 4 styles = 80 snapshots) |
| 4.2 | Unit tests: theme resolution, token access, enum switching |
| 4.3 | Catalog app: browsable component showcase with style switching |
| 4.4 | README: how to add a new style, how to consume in an app |

### Phase 5 — Token Pipeline (Figma Sync)

| Task | Description |
|---|---|
| 5.1 | Set up Tokens Studio in Figma → JSON export |
| 5.2 | Style Dictionary v4 config to generate Swift + Kotlin from JSON |
| 5.3 | CI script: token JSON → platform code (automated) |

---

## 8. Repository Structure

```
design-system/
├── tokens/
│   ├── primitives.json                ← 82 variables × 4 brands (source of truth)
│   └── tokens.json                    ← 51 variables × 4 styles (source of truth)
│
├── ios/
│   ├── Package.swift                   ← SPM manifest (the library entry point)
│   ├── Sources/
│   │   └── DesignSystem/
│   │       ├── Primitives/
│   │       │   ├── BrandPrimitives.swift       ← brand colors + neutrals
│   │       │   └── SharedPrimitives.swift       ← spacing, radius, borderWidth, opacity, dropShadow, semantic
│   │       ├── Tokens/
│   │       │   ├── ColorTokens.swift            ← surface + text + border colors (resolved)
│   │       │   ├── TypographyTokens.swift
│   │       │   ├── SpacingTokens.swift
│   │       │   ├── RadiusTokens.swift
│   │       │   ├── BorderTokens.swift
│   │       │   ├── ElevationTokens.swift
│   │       │   ├── OpacityTokens.swift
│   │       │   └── AnimationTokens.swift
│   │       ├── Theme/
│   │       │   ├── Brand.swift                  ← Brand enum (4 cases → BrandPrimitives)
│   │       │   ├── Style.swift                  ← Style enum (4 cases → maps primitives to tokens)
│   │       │   ├── ThemeConfiguration.swift
│   │       │   └── ThemeProvider.swift
│   │       ├── Components/
│   │       │   ├── DSTextField.swift
│   │       │   ├── DSDropdown.swift
│   │       │   ├── DSTextArea.swift
│   │       │   ├── DSDatePicker.swift
│   │       │   └── DSButton.swift
│   │       ├── Extensions/
│   │       │   ├── View+Theme.swift
│   │       │   └── Color+Hex.swift
│   │       └── Resources/
│   │           └── Fonts/
│   │               ├── DMSans-Regular.ttf
│   │               ├── DMSans-Medium.ttf
│   │               └── DMSans-SemiBold.ttf
│   └── Tests/
│       └── DesignSystemTests/
│           ├── ThemeTests.swift
│           └── SnapshotTests/
│
├── android/
│   ├── build.gradle.kts                ← root build config
│   ├── settings.gradle.kts
│   ├── gradle.properties
│   └── design-system/
│       ├── build.gradle.kts            ← library module (publishes AAR to Maven)
│       └── src/
│           ├── main/
│           │   ├── kotlin/com/designsystem/
│           │   │   ├── primitives/
│           │   │   │   ├── BrandPrimitives.kt
│           │   │   │   └── SharedPrimitives.kt
│           │   │   ├── tokens/
│           │   │   │   ├── ColorTokens.kt
│           │   │   │   ├── TypographyTokens.kt
│           │   │   │   ├── SpacingTokens.kt
│           │   │   │   ├── RadiusTokens.kt
│           │   │   │   ├── BorderTokens.kt
│           │   │   │   ├── ElevationTokens.kt
│           │   │   │   ├── OpacityTokens.kt
│           │   │   │   └── AnimationTokens.kt
│           │   │   ├── theme/
│           │   │   │   ├── Brand.kt
│           │   │   │   ├── Style.kt
│           │   │   │   ├── ThemeConfiguration.kt
│           │   │   │   └── ThemeProvider.kt
│           │   │   └── components/
│           │   │       ├── DSTextField.kt
│           │   │       ├── DSDropdown.kt
│           │   │       ├── DSTextArea.kt
│           │   │       ├── DSDatePicker.kt
│           │   │       └── DSButton.kt
│           │   └── res/
│           │       └── font/
│           │           ├── dm_sans_regular.ttf
│           │           ├── dm_sans_medium.ttf
│           │           └── dm_sans_semibold.ttf
│           └── test/kotlin/
│               ├── ThemeTests.kt
│               └── snapshot/
│
├── docs/
│   └── catalog/
│
├── PRD.md                              ← this file
└── README.md
```

---

## 9. Distribution & Packaging

### 9.1 iOS — Swift Package Manager (SPM)

The iOS design system is distributed as a **Swift Package**. Consumers add it with a single URL.

**Package.swift:**

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DesignSystem",
            resources: [
                .process("Resources")     // Bundles fonts (DM Sans .ttf files)
            ]
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"]
        ),
    ]
)
```

**Consumer integration (Xcode or Package.swift):**

```swift
// In consumer app's Package.swift or Xcode > Add Package Dependency
.package(url: "https://github.com/<org>/design-system.git", from: "1.0.0")

// In target dependencies
.product(name: "DesignSystem", package: "design-system")
```

**Or via Xcode UI:**
1. File → Add Package Dependencies
2. Paste repo URL
3. Select version rule (e.g. "Up to Next Major")

**Consumer usage:**

```swift
import DesignSystem

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .designSystem(brand: .coralCamo, style: .lightRounded)  // two enums
        }
    }
}
```

**SPM-specific requirements:**
- The `Package.swift` lives at `ios/Package.swift` — consumers point SPM to the `ios/` subdirectory or the repo root if structured accordingly
- Fonts are bundled via `.process("Resources")` and loaded from `Bundle.module`
- Zero external dependencies — the package is self-contained
- Tagged releases follow SemVer (e.g., `1.0.0`, `1.1.0`, `2.0.0`)

### 9.2 Android — Gradle / Maven

The Android design system is distributed as an **Android Library (AAR)** published to Maven (GitHub Packages, Maven Central, or internal Artifactory).

**Library build.gradle.kts:**

```kotlin
plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
    id("maven-publish")
}

android {
    namespace = "com.designsystem"
    compileSdk = 35

    defaultConfig {
        minSdk = 24
    }

    buildFeatures {
        compose = true
    }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2025.02.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.foundation:foundation")
    implementation("androidx.compose.material3:material3")  // optional, only if extending Material
    implementation("androidx.compose.ui:ui-text-google-fonts")
}

publishing {
    publications {
        create<MavenPublication>("release") {
            groupId = "com.designsystem"
            artifactId = "design-system"
            version = "1.0.0"

            afterEvaluate {
                from(components["release"])
            }
        }
    }
    repositories {
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/<org>/design-system")
            credentials {
                username = project.findProperty("gpr.user") as String?
                password = project.findProperty("gpr.key") as String?
            }
        }
    }
}
```

**Consumer integration (app build.gradle.kts):**

```kotlin
repositories {
    maven {
        url = uri("https://maven.pkg.github.com/<org>/design-system")
        credentials {
            username = project.findProperty("gpr.user") as String?
            password = project.findProperty("gpr.key") as String?
        }
    }
}

dependencies {
    implementation("com.designsystem:design-system:1.0.0")
}
```

**Consumer usage:**

```kotlin
import com.designsystem.theme.DesignSystemTheme
import com.designsystem.theme.Brand
import com.designsystem.theme.Style

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            DesignSystemTheme(brand = Brand.CoralCamo, style = Style.LightRounded) {
                MyApp()
            }
        }
    }
}
```

**Gradle-specific requirements:**
- Published as AAR with Compose dependencies declared as `api` (transitive)
- Fonts bundled in `src/main/res/font/`
- BOM-aligned Compose dependencies to avoid version conflicts in consumer apps
- ProGuard/R8 rules included for shrinking
- Tagged releases match iOS versioning (same SemVer across platforms)

### 9.3 Versioning Strategy

Both platforms follow **library-wide SemVer**, kept in sync:

| Version | Trigger |
|---|---|
| PATCH (1.0.x) | Bug fixes, token value adjustments, no API changes |
| MINOR (1.x.0) | New components, new enum styles, backward-compatible additions |
| MAJOR (x.0.0) | Breaking API changes (renamed tokens, removed components, changed theme structure) |

**Release process:**
1. Git tag `v1.2.0` on main branch
2. CI builds + publishes iOS Swift Package (tag-based)
3. CI builds + publishes Android AAR to Maven (Gradle publish task)
4. Both platforms always share the same version number

### 9.4 CI/CD Publishing Pipeline

```
Git tag (v1.2.0)
  ├── iOS: swift build → swift test → tag triggers SPM availability
  └── Android: ./gradlew :design-system:publishReleasePublicationToMavenRepository
```

SPM doesn't need a publish step — tagging the repo makes the new version available. Android needs an explicit Gradle publish to Maven.

---

## 10. Technical Constraints

| Constraint | Detail |
|---|---|
| **iOS distribution** | Swift Package Manager (SPM). `Package.swift` at `ios/` root. Zero external dependencies |
| **Android distribution** | Gradle library module → AAR published to Maven (GitHub Packages or Maven Central) |
| **iOS minimum** | iOS 16+ (SwiftUI Environment `@Entry` macro requires iOS 17, fallback with `EnvironmentKey` for 16) |
| **Android minimum** | API 24+ (Jetpack Compose with Compose BOM) |
| **Font** | DM Sans bundled as resource via SPM `Bundle.module` (iOS) / `res/font/` (Android) |
| **Localization** | All user-facing strings via `LocalizedStringKey` (iOS) / `stringResource` (Android). EN/FR/ES minimum |
| **Accessibility** | WCAG 2.1 AA contrast ratios, Dynamic Type support (iOS), font scaling (Android) |
| **No cross-platform layer** | Pure SwiftUI + pure Compose. No KMP for UI. Shared tokens only via JSON |
| **Self-contained** | Both packages have zero third-party dependencies. Only platform SDK + Compose BOM (Android) |

---

## 11. Success Metrics

| Metric | Target |
|---|---|
| **Brand switch effort** | Adding a new brand = 1 file (primitive palette), 0 component changes |
| **Style switch effort** | Adding a new style = 1 file (token mapping), 0 component changes |
| **Component token coverage** | 100% — no hardcoded visual values in any component |
| **Visual parity** | Pixel-accurate match with HaHo Figma for coralCamo + lightRounded |
| **Combination coverage** | All 16 combinations (4 brands × 4 styles) render correctly |
| **Snapshot test coverage** | Every component × every brand × every style (80 snapshots minimum) |
| **Time to new brand** | Under 30 minutes to create a complete new brand palette |

---

## 12. Implementation Order

We implement **one task at a time**, validated before moving to the next:

```
Phase 1.2 → 1.3 → 1.4 → 1.5 → 1.6  (iOS: SPM scaffold → primitives → semantic tokens → enums → theme provider)
  ↓
Phase 2.5 → 2.1 → 2.2 → 2.3 → 2.4  (iOS components, button first since others depend on it)
  ↓
Phase 3.1 → 3.2 → 3.3 → 3.4 → 3.5  (prove all 16 brand×style combinations on iOS)
  ↓
Phase 1.7 → 1.8 → 1.9 → 1.10 → 1.11  (Android: Gradle scaffold → primitives → semantic tokens → enums → theme provider)
  ↓
Phase 2.5 → 2.1 → 2.2 → 2.3 → 2.4  (Android components)
  ↓
Phase 4 → 5  (testing, automation, CI publishing)
```

**iOS first** as the primary implementation, then Android mirrors the same architecture.

---

## Appendix A: Complete Token Data Reference

Source: Figma file `4kcXyu53LWpUMVyhPvA4hY`, variable set `2-5334`

### A.1 Data Files

Complete token data is stored as structured JSON:

| File | Content | Variables | Modes |
|---|---|---|---|
| `tokens/primitives.json` | Raw values: brand colors, neutrals, semantic, spacing, radius, borderWidth, opacity, dropShadow | 82 | 4 brands (coralCamo, seaLime, mistyRose, blueHaze) |
| `tokens/tokens.json` | Semantic mappings: surface, text, border, radius, spacing, boolean | 51 | 4 styles (lightRounded, darkRounded, lightSharp, darkSharp) |

### A.2 Architecture Summary

```
82 Primitives (per Brand)              51 Tokens (per Style)
─────────────────────────              ─────────────────────
 7 brand colors                         7 surface tokens
15 neutral steps                        9 text tokens
 4 semantic colors                     13 border tokens
11 spacing values                      10 radius tokens
10 radius values                       11 spacing tokens (pass-through)
 4 border widths                        1 boolean token
 5 opacity levels
26 drop shadow values
 + typography (shared)
```

### A.3 Dark Mode Inversion Rules

| Light Mode | Dark Mode |
|---|---|
| `neutrals.0.5` | `neutrals.9` |
| `neutrals.2` | `neutrals.8.5` |
| `neutrals.3` | `neutrals.8` |
| `neutrals.9` | `neutrals.0.5` |
| `brand.primary100` | `brand.secondary100` |
| `brand.primary120` | `neutrals.5` |
| `brand.secondary100` | `brand.primary100` |

### A.4 Sharp Mode Radius Rules

All radius values → 0, **except** `radiusFull` which remains 360 (pill shape preserved).

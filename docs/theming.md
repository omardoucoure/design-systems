# Theming — HaHo Design System

## Overview

The theme system has two axes:

| Axis | Type | Controls |
|------|------|----------|
| **Brand** | `Brand` enum | Primary + secondary color palette, neutral scale undertone |
| **Style** | `Style` enum | Light/dark mode, rounded/sharp radius |

Together they resolve a fully typed `ThemeConfiguration` that every DS component reads via `@Environment(\.theme)`.

---

## Quick Start

### Applying the theme

```swift
// Option 1 — view modifier (most common)
ContentView()
    .designSystem(brand: .coralCamo, style: .lightRounded)

// Option 2 — container view
ThemeProvider(brand: .coralCamo, style: .lightRounded) {
    ContentView()
}
```

### Reading the theme in a component

```swift
struct MyView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        Text("Hello")
            .font(theme.typography.h4.font)
            .foregroundStyle(theme.colors.textNeutral9)
            .padding(theme.spacing.md)
    }
}
```

---

## Brand

Four built-in brands, each providing a primary color family, a secondary (accent) color family, and a 15-step neutral scale with its own undertone:

| Case | Primary | Secondary/Accent | Neutral undertone |
|------|---------|------------------|-------------------|
| `.coralCamo` | Forest green | Coral red | Warm |
| `.seaLime` | Navy blue | Lime green | Cool green |
| `.mistyRose` | Slate blue | Pink | Cool blue |
| `.blueHaze` | Royal blue | Beige | Warm grey |

---

## Style

| Case | Mode | Corners |
|------|------|---------|
| `.lightRounded` | Light | Rounded |
| `.darkRounded` | Dark | Rounded |
| `.lightSharp` | Light | Sharp (0 radius) |
| `.darkSharp` | Dark | Sharp (0 radius) |

**Convenience init:**
```swift
Style(isDark: true, isSharp: false) // → .darkRounded
```

---

## Custom Brand Colors

Any app importing the design system can replace the built-in primary and/or secondary color with its own brand color. The design system automatically derives all color shades from the provided base.

### Usage

```swift
// Both overrides
ContentView()
    .designSystem(
        brand: .coralCamo,     // neutral scale comes from the brand
        style: .lightRounded,
        primaryColor: Color(hex: "#1A73E8"),
        secondaryColor: Color(hex: "#EA4335")
    )

// Primary only
ContentView()
    .designSystem(
        brand: .seaLime,
        style: .lightRounded,
        primaryColor: Color(hex: "#6750A4")
    )

// With ThemeProvider
ThemeProvider(
    brand: .coralCamo,
    style: .lightRounded,
    primaryColor: .purple,
    secondaryColor: .orange
) {
    ContentView()
}
```

### What gets derived automatically

When you pass `primaryColor: myColor`, the system generates:

| Shade | Derivation | Used for |
|-------|-----------|----------|
| `primary80` | `myColor.opacity(0.7)` | Muted/secondary surfaces |
| `primary100` | `myColor` (exact) | Main surfaces, buttons |
| `primary120` | `myColor` darkened 15% (HSB) | Pressed states, deeper fills |

When you pass `secondaryColor: myColor`:

| Shade | Derivation | Used for |
|-------|-----------|----------|
| `secondary10` | `myColor.opacity(0.08)` | Tinted backgrounds |
| `secondary40` | `myColor.opacity(0.35)` | Hover/selection fills |
| `secondary100` | `myColor` (exact) | Accent surfaces, `.filledA` buttons |
| `secondary120` | `myColor` darkened 10% (HSB) | Pressed accent states |

### Which semantic tokens are affected

All tokens that flow from primary/secondary primitives update instantly:

| Token | Affected by |
|-------|-------------|
| `theme.colors.surfacePrimary100` | `primaryColor` |
| `theme.colors.surfacePrimary120` | `primaryColor` |
| `theme.colors.surfaceSecondary100` | `secondaryColor` |
| `theme.colors.textPrimary100` | `primaryColor` |
| `theme.colors.textSecondary100` | `secondaryColor` |
| `theme.colors.borderPrimary100` | `primaryColor` |
| `theme.colors.borderSecondary100` | `secondaryColor` |

### Which components respond to custom colors

Every DS component that uses the semantic color tokens listed above automatically reflects custom colors — no component-level changes needed:

- `DSButton` styles `.filledA` (secondary), `.filledB` (primary100), `.filledC` (primary120)
- `DSBottomAppBar` tab selection highlight
- `DSTextField` active/validated border
- `DSCheckbox`, `DSRadio`, `DSToggle` selected state
- `DSProgressCircle` progress arc
- `DSChip`, `DSBadge` filled variants
- All other components using `surfacePrimary*` / `surfaceSecondary*`

---

## Color Tokens

All semantic color tokens are on `theme.colors`:

### Surface
| Token | Light value | Dark value |
|-------|-------------|------------|
| `surfaceNeutral0_5` | Lightest background | Darkest background |
| `surfaceNeutral1` | Subtle card bg | — |
| `surfaceNeutral2` | Card background | — |
| `surfaceNeutral3` | Stronger border bg | — |
| `surfaceNeutral9` | Inverted bg | — |
| `surfacePrimary100` | Brand primary | Swapped with secondary |
| `surfacePrimary120` | Darker primary | — |
| `surfaceSecondary100` | Brand accent | Swapped with primary |

### Text
| Token | Use |
|-------|-----|
| `textNeutral9` | Body / heading text (default) |
| `textNeutral8` | Secondary text |
| `textNeutral3` | Disabled / placeholder |
| `textNeutral0_5` | Text on dark/colored surfaces |
| `textPrimary100` | Primary-colored text |
| `textSecondary100` | Accent-colored text |

### Border
| Token | Use |
|-------|-----|
| `borderNeutral2` | Default card border |
| `borderNeutral3` | Stronger separator |
| `borderPrimary100` | Focused input |
| `borderSecondary100` | Accent border |

### Semantic
| Token | Use |
|-------|-----|
| `error` | Error states, destructive |
| `warning` | Warning states |
| `validated` | Success / validated |
| `infoFocus` | Focus / info badges |

---

## Spacing Tokens

`theme.spacing.*` — all values in points:

| Token | Value |
|-------|-------|
| `xxs` | 4 |
| `xs` | 8 |
| `sm` | 12 |
| `md` | 16 |
| `lg` | 24 |
| `xl` | 32 |
| `xxl` | 40 |
| `xxxl` | 48 |
| `xxxxl` | 64 |

---

## Radius Tokens

`theme.radius.*` — zero in `.sharp` styles:

| Token | Rounded | Sharp |
|-------|---------|-------|
| `xs` | 4 | 0 |
| `sm` | 8 | 0 |
| `md` | 16 | 0 |
| `lg` | 20 | 0 |
| `xl` | 32 | 0 |
| `full` | 9999 | 9999 |

---

## Typography Tokens

`theme.typography.*` — each token has `.font` (SwiftUI `Font`) and `.tracking` (letter spacing):

| Token | Size | Weight |
|-------|------|--------|
| `h2` | 36px | Medium |
| `h3` | 30px | Medium |
| `h4` | 24px | Medium |
| `h5` | 20px | Medium |
| `h6` | 18px | Medium |
| `largeSemiBold` | 18px | SemiBold |
| `bodySemiBold` | 16px | SemiBold |
| `body` | 16px | Medium |
| `bodyRegular` | 16px | Regular |
| `label` | 14px | SemiBold |
| `caption` | 14px | Medium |
| `small` | 12px | Medium |
| `smallRegular` | 12px | Regular |

**Usage:**
```swift
Text("Title")
    .font(theme.typography.h4.font)
    .tracking(theme.typography.h4.tracking)
```

---

## Rules for AI Implementing Pages

1. **NEVER** hardcode colors, fonts, spacing, or radius — always use `theme.*` tokens.
2. **NEVER** call `.font(.system(size:))` or `.font(.custom(...))` — always use `theme.typography.*`.
3. **NEVER** use `Color(hex:)` inline in page/component files — only in theme primitives.
4. **ALWAYS** apply the theme via `.designSystem(brand:style:)` at the app root — do not inject `ThemeConfiguration` manually elsewhere.
5. **ALWAYS** use the neutral scale from the `Brand` — even with custom primary/secondary, the neutrals are brand-specific and must not be overridden.
6. Custom `primaryColor`/`secondaryColor` affect all components automatically — do not try to override individual component colors to match a brand color.

# Contributing

## Design System Rules

- Prefer DS components over raw SwiftUI controls in the showcase app.
- Prefer semantic tokens and component tokens over raw visual literals in the package.
- When a pattern repeats across pages, extract it into `ios/Sources/DesignSystem/Components`.
- Keep page files thin: composition, local state, and navigation only.

## Token Layers

Use the layers in this order:

1. Primitive tokens in `tokens/primitives.json`
2. Semantic tokens in `tokens/tokens.json`
3. Runtime theme tokens in `ios/Sources/DesignSystem/Tokens`
4. Component tokens for control-specific metrics and behavior

Component-specific values such as button heights, icon sizes, or input spacing should live in component tokens instead of being duplicated in multiple views.

## Adding or Updating Components

- Add public components under `ios/Sources/DesignSystem/Components`.
- Use `@Environment(\.theme)` for colors, typography, spacing, border widths, elevation, and component tokens.
- Prefer enums for variants and states.
- Accept `LocalizedStringKey` for user-facing copy when practical.
- Add a preview or a showcase entry so the component is discoverable.

## Accessibility Baseline

Every new interactive component should be checked for:

- meaningful text or accessibility labels
- adequate touch target sizing
- legible contrast in light and dark styles
- state communication for error, validation, selected, and disabled states

## Tests and Verification

- Add or update unit tests when token resolution changes.
- Add visual or snapshot-style coverage for component variants when possible.
- Run package tests before finishing changes.

## Docs

If you add a new public component or token layer, update:

- [`README.md`](README.md)
- showcase coverage in `VitrineApp`
- any relevant architecture notes in [`PRD.md`](PRD.md)

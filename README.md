# HaHo Design System

HaHo is an iOS-first design system packaged as a Swift Package and previewed through a local showcase app.

The system is built around two theme axes:

- `Brand`: selects the primitive palette
- `Style`: selects color mode and shape treatment

At runtime those axes resolve into a `ThemeConfiguration`, which components read from SwiftUI environment values.

## Repository Layout

- [`ios/Sources/DesignSystem`](ios/Sources/DesignSystem): reusable Swift Package code
- [`ios/VitrineApp`](ios/VitrineApp): showcase app for components, tokens, and sample pages
- [`tokens/primitives.json`](tokens/primitives.json): primitive token source data
- [`tokens/tokens.json`](tokens/tokens.json): semantic token mappings by mode
- [`PRD.md`](PRD.md): product and architecture intent
- [`docs/ACCESSIBILITY.md`](docs/ACCESSIBILITY.md): accessibility expectations for components and pages
- [`docs/components`](docs/components): component usage notes for public DS primitives

## Quick Start

Import the package and apply a theme at the root of your view tree:

```swift
import DesignSystem

struct AppRoot: View {
    var body: some View {
        ContentView()
            .designSystem(brand: .coralCamo, style: .lightRounded)
    }
}
```

Inside any child view:

```swift
@Environment(\.theme) private var theme
```

Then consume semantic tokens and DS components:

```swift
DSCard(background: theme.colors.surfaceNeutral2) {
    DSText("Hello", style: theme.typography.body, color: theme.colors.textNeutral9)
}
```

## Theme Model

The package currently exposes:

- 4 brands: `coralCamo`, `seaLime`, `mistyRose`, `blueHaze`
- 4 styles: `lightRounded`, `darkRounded`, `lightSharp`, `darkSharp`

This yields 16 supported theme combinations.

Theme resolution follows this pipeline:

`primitives -> semantic tokens -> component tokens -> views`

Primitive and semantic token definitions live in the `tokens/` directory. The runtime Swift code mirrors those values today; keeping those layers aligned is an active maintenance concern.

## Using Components

The recommended composition order is:

1. Apply `.designSystem(...)` at the app or screen root.
2. Build layouts from DS components first.
3. Reach for semantic tokens only when composing layout or content around DS components.
4. Add a new DS component when a pattern repeats across pages.

Examples:

- Buttons: [`DSButton.swift`](ios/Sources/DesignSystem/Components/DSButton.swift)
- Inputs: [`DSTextField.swift`](ios/Sources/DesignSystem/Components/DSTextField.swift)
- List rows: [`DSListItem.swift`](ios/Sources/DesignSystem/Components/DSListItem.swift)

## Current Standards

- Package components should prefer theme tokens and component tokens over raw visual literals.
- Pages in the showcase app should demonstrate DS primitives instead of rebuilding controls inline.
- Accessibility labels, control states, and consumer-facing examples should be added alongside new components.

## Gaps

The repo already has a strong token and theme core, but it still needs:

- generated token artifacts from a single source of truth
- broader component tests and visual regression coverage
- richer accessibility guidance
- fuller component documentation beyond showcase examples

## Contributing

Contribution rules and implementation guardrails are documented in [`CONTRIBUTING.md`](CONTRIBUTING.md).

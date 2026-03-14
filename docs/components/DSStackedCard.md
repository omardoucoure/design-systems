# DSStackedCard

[`DSStackedCard`](../../ios/Sources/DesignSystem/Components/DSStackedCard.swift) is a stacked depth-effect card container with layered background cards.

## Purpose

Use `DSStackedCard` for:

- hero cards with visual depth
- card decks with peek effect
- layered container presentations

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `levels` | `[DSStackedCardLevel]` | — | Background layer definitions |
| `alignment` | `DSStackedCardAlignment` | `.top` | Stack direction |
| `frontOffset` | `CGFloat` | `39` | Front card offset from edge |
| `frontBackground` | `Color?` | `nil` | Front card background |
| `backgroundCardColor` | `Color?` | `nil` | Background cards color |
| `content` | `() -> Content` | — | Front card content |

## Data Model

```swift
DSStackedCardLevel(horizontalInset: 16, darkOverlay: 0.1, peekOffset: 8)
```

## Example

```swift
DSStackedCard(
    levels: [
        DSStackedCardLevel(horizontalInset: 16, darkOverlay: 0.05, peekOffset: 8),
        DSStackedCardLevel(horizontalInset: 32, darkOverlay: 0.1, peekOffset: 16)
    ],
    alignment: .top,
    frontBackground: theme.colors.surfaceNeutral2
) {
    CardContent()
}
```

---

## AI Reference

> **For AI agents implementing this component:** Always consult these files before writing code.
>
> | Resource | Path | Purpose |
> |----------|------|---------|
> | CLAUDE.md | [`CLAUDE.md`](../../CLAUDE.md) | Component rules, layout patterns, anti-patterns, token mapping |
> | Contract | [`docs/ai/design-system-contract.yaml`](../ai/design-system-contract.yaml) | Machine-readable component registry, variants, ai_roles |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSStackedCard
  category: layout
  path: ../../ios/Sources/DesignSystem/Components/DSStackedCard.swift
  ai_roles: [depth_card]
```

### Key rules

- Depth layered effect — background cards scale behind the foreground card automatically.
- Never build a depth card with manual `ZStack` + `scaleEffect` offsets; always use `DSStackedCard`.
- Use for premium or featured content that needs visual depth emphasis.

# DSStackedCardCarousel

[`DSStackedCardCarousel`](../../ios/Sources/DesignSystem/Components/DSStackedCardCarousel.swift) is a stack of overlapping cards arranged front-to-back with decreasing heights.

## Purpose

Use `DSStackedCardCarousel` for:

- hero card stacks with visual depth
- featured content with stacked card effect
- image browsing with layered card appearance

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `[DSStackedCardCarouselItem]` | — | Card items |
| `cardWidth` | `CGFloat` | `220` | Card width |
| `overlap` | `CGFloat` | `190` | Horizontal overlap between cards |
| `containerHeight` | `CGFloat` | `730` | Total container height |

## Data Model

```swift
DSStackedCardCarouselItem(
    height: 600,
    image: "hero",
    backgroundColor: .blue,
    showGradientOverlay: true
)
```

## Example

```swift
DSStackedCardCarousel(
    items: heroCards,
    cardWidth: 240,
    overlap: 200,
    containerHeight: 750
)
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
- name: DSStackedCardCarousel
  category: layout
  path: ../../ios/Sources/DesignSystem/Components/DSStackedCardCarousel.swift
  ai_roles: [overlapping_card_stack]
```

### Key rules

- Horizontal scroll of overlapping cards — use when Figma shows a peek of the next card behind the current one.
- Never build overlapping card scroll with manual offset calculations; always use `DSStackedCardCarousel`.
- Card content is provided via a generic `content:` view builder closure.

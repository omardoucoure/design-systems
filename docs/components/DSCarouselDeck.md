# DSCarouselDeck

[`DSCarouselDeck`](../../ios/Sources/DesignSystem/Components/DSCarouselDeck.swift) is a swipeable photo carousel with a double-container deck effect.

## Purpose

Use `DSCarouselDeck` for:

- hero image displays with layered visual depth
- featured content carousels
- stacked card browsing

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `images` | `[String]` | — | Image asset names |
| `currentIndex` | `Binding<Int>` | — | Active card index |
| `cardHeight` | `CGFloat` | `260` | Height of each card |

## Example

```swift
DSCarouselDeck(
    images: ["photo1", "photo2", "photo3"],
    currentIndex: $index,
    cardHeight: 280
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
- name: DSCarouselDeck
  category: layout
  path: ../../ios/Sources/DesignSystem/Components/DSCarouselDeck.swift
  ai_roles: [stacked_card_carousel]
```

### Key rules

- Stacked deck with parallax effect — for photo galleries and immersive card stacks.
- Never build a manual deck stack with `ZStack` offsets; always use `DSCarouselDeck`.
- Background cards scale behind the foreground card automatically.

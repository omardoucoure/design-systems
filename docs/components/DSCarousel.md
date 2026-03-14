# DSCarousel

[`DSCarousel`](../../ios/Sources/DesignSystem/Components/DSCarousel.swift) is a horizontal swipeable image carousel with rounded corners and peek effect.

## Purpose

Use `DSCarousel` for:

- image galleries
- onboarding slides
- product image browsing

## Styles

- `spotlight` — active item zooms in, neighbors peek at edges
- `standard` — flat scrolling with equal sizing

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `images` | `[String]` | — | Image asset names |
| `currentIndex` | `Binding<Int>` | — | Active slide index |
| `style` | `DSCarouselStyle` | `.spotlight` | Carousel behavior |

## Example

```swift
DSCarousel(
    images: ["hero1", "hero2", "hero3"],
    currentIndex: $page,
    style: .spotlight
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
> | Component YAML | [`docs/ai/components/DSCarousel.yaml`](../ai/components/DSCarousel.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSCarousel
  category: layout
  path: ../../ios/Sources/DesignSystem/Components/DSCarousel.swift
  variants: [spotlight, standard]
  ai_roles: [image_carousel, hero_carousel]
```

### Key rules

- `.spotlight` style zooms the center item (parallax focus); `.standard` is flat — choose based on Figma design.
- Never build a manual `TabView`-based carousel when `DSCarousel` applies.
- Pair with `DSPageControl` to show progress dots below the carousel.

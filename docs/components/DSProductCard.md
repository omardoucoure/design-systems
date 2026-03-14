# DSProductCard

[`DSProductCard`](../../ios/Sources/DesignSystem/Components/DSProductCard.swift) is a product card with photo, brand, subtitle, price, and optional discount badge.

## Purpose

Use `DSProductCard` for:

- product listings in shopping interfaces
- product detail previews
- cards with price and discount display

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `image` | `String` | — | Image asset name |
| `brand` | `LocalizedStringKey` | — | Brand/title text |
| `subtitle` | `LocalizedStringKey` | — | Product description |
| `price` | `String` | — | Current price |
| `originalPrice` | `String?` | `nil` | Strikethrough original price |
| `discount` | `String?` | `nil` | Discount badge text (e.g., "-20%") |
| `photoWidth` | `CGFloat` | `240` | Image width |
| `photoHeight` | `CGFloat` | `311` | Image height |

## Example

```swift
DSProductCard(
    image: "sneaker",
    brand: "Nike",
    subtitle: "Air Max 90",
    price: "$129",
    originalPrice: "$159",
    discount: "-19%"
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
> | Component YAML | [`docs/ai/components/DSProductCard.yaml`](../ai/components/DSProductCard.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSProductCard
  category: content
  path: ../../ios/Sources/DesignSystem/Components/DSProductCard.swift
  ai_roles: [product_listing_card]
```

### Key rules

- Photo + price + optional discount badge — tappable; never build product cards inline.
- Read price format and discount badge presence from Figma; discount badge is optional.
- Use inside `DSProductTeaser` for horizontal carousel layouts.

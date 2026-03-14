# DSProductTeaser

[`DSProductTeaser`](../../ios/Sources/DesignSystem/Components/DSProductTeaser.swift) is a horizontal scrolling row of product cards.

## Purpose

Use `DSProductTeaser` for:

- featured product carousels
- "You might also like" sections
- horizontal product browsing

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `products` | `[DSProductTeaserItem]` | — | Product items |
| `height` | `CGFloat` | `400` | Card height |

## Data Model

```swift
DSProductTeaserItem(
    image: "shoe",
    brand: "Nike",
    subtitle: "Air Max",
    price: "$129",
    originalPrice: "$159",
    discount: "-19%"
)
```

## Example

```swift
DSProductTeaser(products: featuredProducts, height: 420)
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
- name: DSProductTeaser
  category: content
  path: ../../ios/Sources/DesignSystem/Components/DSProductTeaser.swift
  ai_roles: [horizontal_product_carousel]
```

### Key rules

- Horizontal scrolling carousel of `DSProductCard` items — never build a manual `ScrollView(. horizontal)` product row.
- Pass products as an array; the component handles scroll behavior and card sizing.
- Read section title from Figma and pass it as the `title` parameter.

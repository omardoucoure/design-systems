# DSCard

[`DSCard`](../../ios/Sources/DesignSystem/Components/DSCard.swift) is a themed container card — the building block for page layouts.

## Purpose

Use `DSCard` for:

- section containers on pages
- background-colored content groups
- any "grey container" or "primary container" pattern from Figma

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `background` | `Color?` | `nil` | Card background color |
| `radius` | `CGFloat?` | `nil` | Corner radius |
| `padding` | `CGFloat?` | `nil` | Inner padding (use `0` for asymmetric) |
| `clipsContent` | `Bool` | `true` | Clip content to rounded shape |
| `content` | `() -> Content` | — | Card content |

## Asymmetric Padding

When Figma specifies different horizontal and vertical padding, set `padding: 0` and apply manually:

```swift
DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: 0) {
    content
        .padding(.horizontal, theme.spacing.xl)
        .padding(.vertical, theme.spacing.xxl)
}
```

## Example

```swift
DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl) {
    VStack(spacing: theme.spacing.md) {
        Text("Section Title")
        Text("Content here")
    }
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
> | Component YAML | [`docs/ai/components/DSCard.yaml`](../ai/components/DSCard.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSCard
  category: layout
  path: ../../ios/Sources/DesignSystem/Components/DSCard.swift
  ai_roles: [surface_container, section_card]
```

### Key rules

- Use `padding: 0` for asymmetric padding, then apply `.padding(.horizontal, ...)` and `.padding(.vertical, ...)` manually on the content.
- Never use `RoundedRectangle.fill` inline in pages — always use `DSCard` as the container.
- Always `DSCard` as the surface container in page layouts; never build raw containers with `.background().clipShape()`.
- When Figma shows `mb-[-50px]`, implement with `.padding(.top, -50)` on the next card in the `VStack`.

# DSBadge

[`DSBadge`](../../ios/Sources/DesignSystem/Components/DSBadge.swift) is a themed badge for status indicators, counts, or text labels.

## Purpose

Use `DSBadge` for:

- notification count indicators
- status dots on avatars or icons
- text tag labels

## Variants

- `dot` — small colored dot (no text)
- `numberBrand` — numeric count with brand color
- `numberSemantic` — numeric count with semantic color
- `tagBrand` — text label with brand color
- `tagSemantic` — text label with semantic color

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `variant` | `DSBadgeVariant` | `.dot` | Badge style |
| `count` | `Int` | `0` | Number displayed (for number variants) |
| `text` | `LocalizedStringKey` | `""` | Text displayed (for tag variants) |

## Example

```swift
DSBadge(variant: .dot)
DSBadge(variant: .numberBrand, count: 5)
DSBadge(variant: .tagSemantic, text: "New")
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
- name: DSBadge
  category: feedback
  path: ../../ios/Sources/DesignSystem/Components/DSBadge.swift
  variants: [dot, numberBrand, numberSemantic, tagBrand, tagSemantic]
  ai_roles: [count_badge, status_badge, dot_indicator]
```

### Key rules

- Always overlay with `ZStack(alignment: .topTrailing)` when attaching to another component.
- Choose variant from Figma: dot indicator → `.dot`, count number → `.numberBrand`/`.numberSemantic`, label tag → `.tagBrand`/`.tagSemantic`.
- Never build a custom badge with a manual circle overlay.

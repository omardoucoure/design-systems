# DSDivider

[`DSDivider`](../../ios/Sources/DesignSystem/Components/DSDivider.swift) is a themed divider with four style variants.

## Purpose

Use `DSDivider` for:

- separating list items
- section breaks
- labeled subheaders within content

## Styles

- `fullBleed` — edge-to-edge line
- `inset` — line with leading/trailing inset
- `middle` — centered shorter line
- `subheader(LocalizedStringKey)` — line with a text label

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `style` | `DSDividerStyle` | `.fullBleed` | Divider variant |
| `color` | `Color?` | `nil` | Override default divider color |

## Example

```swift
DSDivider(style: .fullBleed)
DSDivider(style: .subheader("Section Title"))
DSDivider(style: .inset, color: theme.colors.borderNeutral2)
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
- name: DSDivider
  category: navigation
  path: ../../ios/Sources/DesignSystem/Components/DSDivider.swift
  variants: [fullBleed, inset, middle, subheader]
  ai_roles: [content_separator, section_label]
```

### Key rules

- `.fullBleed` extends edge-to-edge; `.inset` leaves leading space; `.middle` has equal margins; `.subheader` shows a section title.
- Accepts an optional `color` parameter to override the default divider color — use theme tokens, not hex literals.
- Never use a manual `Rectangle().frame(height: 1)` as a divider; always use `DSDivider`.

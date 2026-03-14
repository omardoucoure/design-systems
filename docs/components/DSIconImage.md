# DSIconImage

[`DSIconImage`](../../ios/Sources/DesignSystem/Components/DSIconImage.swift) is a themed icon view that renders a `DSIcon` with a given size and color.

## Purpose

Use `DSIconImage` for:

- rendering custom icons from the DSIcon catalog
- replacing the 5-line `Image(...).resizable().renderingMode(...)` pattern
- consistent icon sizing and coloring

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `icon` | `DSIcon` | — | Icon to render |
| `size` | `CGFloat` | `24` | Icon frame size |
| `color` | `Color` | — | Tint color |

## Example

```swift
DSIconImage(.heart, size: 20, color: theme.colors.textNeutral9)
DSIconImage(.chevronRight, color: theme.colors.textNeutral5)
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
- name: DSIconImage
  category: media
  path: ../../ios/Sources/DesignSystem/Components/DSIconImage.swift
  ai_roles: [themed_icon_render]
```

### Key rules

- Use instead of the 5-line `Image(dsIcon:).resizable().renderingMode(.template).scaledToFit().frame()` pattern.
- Color must come from theme tokens — never hardcode a hex color for an icon.
- Always prefer `DSIconImage` over manual icon composition in pages and components.

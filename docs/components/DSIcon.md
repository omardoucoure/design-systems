# DSIcon

[`DSIcon`](../../ios/Sources/DesignSystem/Components/DSIcon.swift) is a type-safe enum referencing all 1364 icons in the asset catalog.

## Purpose

Use `DSIcon` for:

- referencing custom icons by name without raw strings
- compile-time safety for icon usage
- consistent icon naming across the app

## Usage

`DSIcon` is not a view itself — use it with `DSIconImage` to render:

```swift
DSIconImage(.heart, color: theme.colors.textNeutral9)
```

Or pass to components that accept `DSIcon`:

```swift
DSButton(style: .neutral, size: .medium, icon: .menuScale) { }
DSEventCard(title: "Event", subtitle: "9am", icon: .calendar, ...)
```

## Notes

- All icons are normalized to a 24×24 viewBox
- Swift keyword cases are escaped with backticks (e.g., `.import`, `.repeat`)
- Icons preserve vector representation for crisp rendering at any size

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
- name: DSIcon
  category: media
  path: ../../ios/Sources/DesignSystem/Components/DSIcon.swift
  notes: large asset-backed icon catalog; use icon enum values rather than raw image names
  ai_roles: [icon_reference_catalog]
```

### Key rules

- Always use `Image(dsIcon:)` — never use `Image("icon_name")` with a string literal.
- Icons load from `.module` bundle; do not reference the asset catalog by path.
- Never substitute SF Symbols when Figma provides custom vector icons — download SVG assets and use the `DSIcon` enum.
- Swift keywords in icon names are escaped with backticks (e.g., `` .`import` ``).

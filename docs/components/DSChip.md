# DSChip

[`DSChip`](../../ios/Sources/DesignSystem/Components/DSChip.swift) is a themed chip/tag component with tap and dismiss support.

## Purpose

Use `DSChip` for:

- filter tags
- selectable categories
- dismissible labels

## Styles

- `filledA` — secondary color
- `filledB` — primary color
- `filledC` — dark primary color
- `neutral` — neutral fill
- `outlined` — bordered outline

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | `LocalizedStringKey` | — | Chip text |
| `style` | `DSChipStyle` | `.filledA` | Visual style |
| `onTap` | `(() -> Void)?` | `nil` | Tap handler |
| `onDismiss` | `(() -> Void)?` | `nil` | Dismiss handler (shows X button) |

## Example

```swift
DSChip("Trending", style: .filledA, onTap: { filter("trending") })
DSChip("New York", style: .outlined, onDismiss: { removeFilter("ny") })
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
- name: DSChip
  category: actions
  path: ../../ios/Sources/DesignSystem/Components/DSChip.swift
  variants: [filledA, filledB, filledC, neutral, outlined]
  ai_roles: [filter_chip, status_chip, tag]
```

### Key rules

- Tappable or dismissible; use for filters and tags — never build an inline pill with `HStack` + `Text` + `RoundedRectangle`.
- Read the chip style from Figma background color using the same mapping as `DSButton` styles.
- Use dismissible chips when Figma shows an `×` icon; use tappable chips for filter rows.

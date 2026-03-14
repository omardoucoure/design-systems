# DSListItem

[`DSListItem`](../../ios/Sources/DesignSystem/Components/DSListItem.swift) is a themed list row with slots for leading, trailing, and text content.

## Purpose

Use `DSListItem` for:

- settings rows
- contact/user lists
- any row with icon + text + action pattern

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `overline` | `LocalizedStringKey?` | `nil` | Small text above headline |
| `headline` | `LocalizedStringKey` | — | Primary text |
| `supportingText` | `LocalizedStringKey?` | `nil` | Secondary text below headline |
| `metadata` | `LocalizedStringKey?` | `nil` | Trailing metadata text |
| `showDivider` | `Bool` | `false` | Show bottom divider |
| `action` | `(() -> Void)?` | `nil` | Row tap handler |
| `leading` | `() -> Leading` | — | Leading slot (icon, avatar) |
| `trailing` | `() -> Trailing` | — | Trailing slot (arrow, toggle) |

Convenience initializers are available for common patterns:

- Leading icon with trailing arrow: `init(headline:, leadingIcon:, showTrailingArrow:)`
- Leading-only or trailing-only variants

## Example

```swift
DSListItem(
    overline: "Account",
    headline: "Edit profile",
    leadingIcon: "person",
    showTrailingArrow: true
) { navigateToProfile() }

DSListItem(headline: "Notifications") {
    DSAvatar(style: .icon("bell"), size: 32)
} trailing: {
    DSToggle(isOn: $notificationsEnabled)
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
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSListItem
  category: navigation
  path: ../../ios/Sources/DesignSystem/Components/DSListItem.swift
  slots: [leading, text_block, metadata, trailing]
  ai_roles: [list_row, settings_row, actionable_row]
```

### Key rules

- Never build list rows manually with `HStack` — always use `DSListItem`.
- Use generic `leading:` and `trailing:` slots for custom content (avatars, badges, toggles).
- `overline`, `headline`, and `metadata` text slots all accept `LocalizedStringKey`.
- Pair with `DSDivider` between rows in a list.

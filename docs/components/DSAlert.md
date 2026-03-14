# DSAlert

[`DSAlert`](../../ios/Sources/DesignSystem/Components/DSAlert.swift) is a full-page alert layout with icon, title, message, and action buttons.

## Purpose

Use `DSAlert` for:

- full-screen informational or error states
- confirmation screens after an action
- empty states with call-to-action buttons

## Severity

- `error`
- `warning`
- `success`
- `info`
- `neutral`

Each severity maps to a distinct color scheme via theme tokens.

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `LocalizedStringKey` | — | Alert headline |
| `message` | `LocalizedStringKey?` | `nil` | Optional body text |
| `severity` | `DSAlertSeverity` | — | Color scheme |
| `showDivider` | `Bool` | `true` | Show divider between message and actions |
| `icon` | `() -> Icon` | — | Leading icon view |
| `actions` | `() -> Actions` | — | Action buttons |

## Accessibility

- Use clear, descriptive titles that convey the alert meaning.
- Action buttons should have distinct labels (e.g., "Retry" instead of "OK").

## Example

```swift
DSAlert(
    title: "Payment failed",
    message: "Please check your card details and try again.",
    severity: .error,
    icon: { DSIconImage(.alertCircle, color: theme.colors.textNeutral9) },
    actions: {
        DSButton("Retry", style: .filledA, size: .big) { retry() }
    }
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
> | Component YAML | [`docs/ai/components/DSAlert.yaml`](../ai/components/DSAlert.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSAlert
  category: feedback
  path: ../../ios/Sources/DesignSystem/Components/DSAlert.swift
  variants: [error, warning, success, info, neutral]
  ai_roles: [inline_alert]
```

### Key rules

- Severity drives icon and color automatically — never hardcode alert colors or icons.
- Always placed inline in the layout (not as an overlay); use `DSAlertDialog` for modal alerts.
- Read the severity variant from Figma's color and icon — do not default to `.neutral`.

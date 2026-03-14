# DSBanner

[`DSBanner`](../../ios/Sources/DesignSystem/Components/DSBanner.swift) is a floating banner/toast notification with severity-colored background.

## Purpose

Use `DSBanner` for:

- success/error toast messages
- informational banners
- dismissible notifications

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `LocalizedStringKey?` | `nil` | Bold headline |
| `message` | `LocalizedStringKey?` | `nil` | Body text |
| `severity` | `DSAlertSeverity` | — | Background color scheme |
| `leading` | `() -> LeadingContent` | — | Optional leading content (icon) |
| `onDismiss` | `(() -> Void)?` | `nil` | Dismiss handler (shows close button) |

## Example

```swift
DSBanner(
    title: "Saved",
    message: "Your changes have been saved.",
    severity: .success,
    leading: { DSIconImage(.checkCircle, color: .white) },
    onDismiss: { hideBanner() }
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
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSBanner
  category: feedback
  path: ../../ios/Sources/DesignSystem/Components/DSBanner.swift
  ai_roles: [banner_notice, warning_banner, success_banner]
```

### Key rules

- Floating toast — use `.overlay` or `.safeAreaInset` to position without affecting layout flow.
- Never place inline in a VStack; it must float over content.
- Severity and icon are data-driven — never hardcode banner colors.

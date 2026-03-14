# DSAlertDialog

[`DSAlertDialog`](../../ios/Sources/DesignSystem/Components/DSAlertDialog.swift) is a modal dialog overlay with dimming background and centered alert card.

## Purpose

Use `DSAlertDialog` for:

- confirmation prompts before destructive actions
- modal alerts requiring user acknowledgment
- dialogs with optional custom content between message and actions

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isPresented` | `Binding<Bool>` | — | Controls visibility |
| `title` | `LocalizedStringKey` | — | Dialog title |
| `message` | `LocalizedStringKey?` | `nil` | Optional body text |
| `severity` | `DSAlertSeverity` | — | Color scheme for icon |
| `icon` | `() -> Icon` | — | Icon view (or use `assetIcon`/`systemIcon`) |
| `content` | `() -> Content` | — | Optional custom content slot |
| `actions` | `() -> Actions` | — | Action buttons |

## Accessibility

- Ensure the dialog traps focus when presented.
- Provide a clear dismiss path (cancel button or background tap).

## Example

```swift
DSAlertDialog(
    isPresented: $showDialog,
    title: "Delete account?",
    message: "This action cannot be undone.",
    severity: .error,
    assetIcon: "trash",
    actions: {
        DSButton("Cancel", style: .outlined, size: .medium) { showDialog = false }
        DSButton("Delete", style: .filledA, size: .medium) { deleteAccount() }
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
> | Component YAML | [`docs/ai/components/DSAlertDialog.yaml`](../ai/components/DSAlertDialog.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSAlertDialog
  category: feedback
  path: ../../ios/Sources/DesignSystem/Components/DSAlertDialog.swift
  ai_roles: [modal_alert, destructive_confirmation, permission_prompt]
```

### Key rules

- Always overlays full screen — wrap in a `ZStack` and center it; never place inline in the layout.
- Use for destructive confirmations and permission prompts, not for inline feedback (use `DSAlert` for that).
- Dismiss action must always be provided to avoid trapping the user.

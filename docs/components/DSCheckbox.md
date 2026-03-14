# DSCheckbox

[`DSCheckbox`](../../ios/Sources/DesignSystem/Components/DSCheckbox.swift) is a themed checkbox with label and optional description.

## Purpose

Use `DSCheckbox` for:

- boolean form inputs
- terms acceptance toggles
- multi-select lists

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isOn` | `Binding<Bool>` | — | Checked state |
| `label` | `LocalizedStringKey?` | `nil` | Primary label |
| `description` | `LocalizedStringKey?` | `nil` | Supporting text below the label |

## Accessibility

- Always provide a `label` for screen readers.
- Description text should clarify the consequence of the toggle.

## Example

```swift
DSCheckbox(
    isOn: $acceptTerms,
    label: "I agree to the terms",
    description: "By checking, you accept our privacy policy."
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
- name: DSCheckbox
  category: selection
  path: ../../ios/Sources/DesignSystem/Components/DSCheckbox.swift
  states: [selected, unselected, disabled]
  ai_roles: [remember_me, checklist, consent]
```

### Key rules

- Bind `isChecked` to a `@State` or `@Binding` Bool; if Figma shows a checked checkbox, initialize the state as `true`.
- Never build a custom toggle checkbox with a manual `Button` + `Image`; always use `DSCheckbox`.
- Disabled state must be set via the `isDisabled` property, not by removing the tap gesture.

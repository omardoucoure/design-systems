# DSToggle

[`DSToggle`](../../ios/Sources/DesignSystem/Components/DSToggle.swift) is a themed toggle switch with label and optional description.

## Purpose

Use `DSToggle` for:

- on/off settings
- feature enable/disable switches
- boolean preferences

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isOn` | `Binding<Bool>` | — | Toggle state |
| `label` | `LocalizedStringKey?` | `nil` | Primary label |
| `description` | `LocalizedStringKey?` | `nil` | Supporting text below the label |

## Accessibility

- Always provide a `label` so screen readers can describe the toggle's purpose.

## Example

```swift
DSToggle(
    isOn: $darkMode,
    label: "Dark mode",
    description: "Switch between light and dark appearance"
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
> | Component YAML | [`docs/ai/components/DSToggle.yaml`](../ai/components/DSToggle.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSToggle
  category: selection
  path: ../../ios/Sources/DesignSystem/Components/DSToggle.swift
  states: [on, off, disabled]
  ai_roles: [settings_toggle]
```

### Key rules

- Bind `isOn` to a `@State` or `@Binding` Bool — drives settings and preference screens.
- Never use SwiftUI's native `Toggle` directly; always use `DSToggle` for consistent styling.
- If Figma shows the toggle in the on position, initialize the state as `true`.

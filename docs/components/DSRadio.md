# DSRadio

[`DSRadio`](../../ios/Sources/DesignSystem/Components/DSRadio.swift) is a themed radio button with label and optional description.

## Purpose

Use `DSRadio` for:

- single-choice selection groups
- form options requiring one selection
- settings with mutually exclusive choices

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isSelected` | `Bool` | — | Selection state |
| `label` | `LocalizedStringKey?` | `nil` | Primary label |
| `description` | `LocalizedStringKey?` | `nil` | Supporting text |
| `action` | `() -> Void` | — | Tap handler |

## Accessibility

- Group related radio buttons and ensure only one can be selected at a time.
- Provide labels for all options.

## Example

```swift
ForEach(options) { option in
    DSRadio(
        isSelected: selectedOption == option.id,
        label: option.name,
        description: option.detail
    ) { selectedOption = option.id }
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
> | Component YAML | [`docs/ai/components/DSRadio.yaml`](../ai/components/DSRadio.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSRadio
  category: selection
  path: ../../ios/Sources/DesignSystem/Components/DSRadio.swift
  states: [selected, unselected, disabled]
  ai_roles: [single_select_choice]
```

### Key rules

- Single-select within a group — use with a `selectedId` binding shared across all radio buttons in the group.
- Never build a custom radio button with a manual `Circle` overlay; always use `DSRadio`.
- If Figma shows a pre-selected option, initialize `selectedId` to that option's value.

# DSDropdown

[`DSDropdown`](../../ios/Sources/DesignSystem/Components/DSDropdown.swift) is a themed dropdown extending DSTextField with chevron trigger and popup menu.

## Purpose

Use `DSDropdown` for:

- single-selection from a list
- form fields requiring a picker
- category/option selectors

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `[DSDropdownItem]` | — | Selectable options |
| `selectedId` | `Binding<String?>` | — | Currently selected item ID |
| `placeholder` | `LocalizedStringKey` | — | Placeholder text |
| `label` | `LocalizedStringKey?` | `nil` | Field label |
| `variant` | `InputVariant` | `.filled` | Visual variant (filled/lined) |

## Data Model

```swift
DSDropdownItem(id: "us", label: "United States")
```

## Example

```swift
DSDropdown(
    items: countries,
    selectedId: $selectedCountry,
    placeholder: "Select country",
    label: "Country",
    variant: .filled
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
> | Component YAML | [`docs/ai/components/DSDropdown.yaml`](../ai/components/DSDropdown.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSDropdown
  category: forms
  path: ../../ios/Sources/DesignSystem/Components/DSDropdown.swift
  ai_roles: [single_select_menu]
```

### Key rules

- Extends `DSTextField` — shows a menu on tap; bind the selected value with a `@Binding<String>`.
- Never build a custom picker with `Menu {}` inline; always use `DSDropdown`.
- Pass options as an array of strings; the component handles the popover/sheet presentation.

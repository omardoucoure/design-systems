# DSSegmentedPicker

[`DSSegmentedPicker`](../../ios/Sources/DesignSystem/Components/DSSegmentedPicker.swift) is a themed segmented control with three style variants.

## Purpose

Use `DSSegmentedPicker` for:

- tab-style navigation within a page
- content category switching
- filter toggles

## Styles

- `tabs` — filled background segments
- `pills` — capsule-shaped segments
- `underline` — text with underline indicator

## Properties

**Init parameters (core):**

| Parameter | Type | Description |
|-----------|------|-------------|
| `items` | `[LocalizedStringKey]` | Segment labels |
| `selectedIndex` | `Binding<Int>` | Active segment index |

**Modifiers:**

| Modifier | Type | Default | Description |
|----------|------|---------|-------------|
| `.pickerStyle(_:)` | `DSSegmentedPickerStyle` | `.tabs` | Visual style |
| `.containerBackground(_:)` | `Color?` | `nil` | Override container background |

## Related: DSPageControl

A companion component for page indicators:

```swift
DSPageControl(count: 5, currentIndex: $page)
```

## Example

```swift
DSSegmentedPicker(
    items: ["Daily", "Weekly", "Monthly"],
    selectedIndex: $tab
)
.pickerStyle(.underline)
```

---

## AI Reference

> **For AI agents implementing this component:** Always consult these files before writing code.
>
> | Resource | Path | Purpose |
> |----------|------|---------|
> | CLAUDE.md | [`CLAUDE.md`](../../CLAUDE.md) | Component rules, layout patterns, anti-patterns, token mapping |
> | Contract | [`docs/ai/design-system-contract.yaml`](../ai/design-system-contract.yaml) | Machine-readable component registry, variants, ai_roles |
> | Component YAML | [`docs/ai/components/DSSegmentedPicker.yaml`](../ai/components/DSSegmentedPicker.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSSegmentedPicker
  category: selection
  path: ../../ios/Sources/DesignSystem/Components/DSSegmentedPicker.swift
  variants: [tabs, pills, underline]
  ai_roles: [mode_switcher, auth_tab_switcher, category_switcher]
```

### Key rules

- Use `.tabs` for nav-style switching (e.g., Login/Register), `.pills` for filter rows, `.underline` for content category tabs.
- Never use SwiftUI's native `Picker` with `.segmented` style — always use `DSSegmentedPicker`.
- Bind selection to a `@State` or `@Binding` that drives the content shown below.

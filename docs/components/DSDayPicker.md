# DSDayPicker

[`DSDayPicker`](../../ios/Sources/DesignSystem/Components/DSDayPicker.swift) is a horizontal scrolling day picker with capsule selections and opacity-based distance fading.

## Purpose

Use `DSDayPicker` for:

- day-of-week selection strips
- schedule day filters
- horizontal pill-style selectors

Items further from the selected one fade out to draw visual focus.

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `[DSDayPickerItem]` | — | Selectable day items |
| `selectedId` | `Binding<String>` | — | Currently selected item ID |

## Data Model

```swift
DSDayPickerItem(id: "mon", label: "Monday")
```

## Example

```swift
DSDayPicker(
    items: weekDays,
    selectedId: $selectedDay
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
> | Component YAML | [`docs/ai/components/DSDayPicker.yaml`](../ai/components/DSDayPicker.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSDayPicker
  category: calendar
  path: ../../ios/Sources/DesignSystem/Components/DSDayPicker.swift
  ai_roles: [day_selector]
```

### Key rules

- Horizontal scroll of days with fade edges — never build a custom horizontal day scroller.
- Date-driven: pass the current selected date as a `@Binding`; the component handles scroll position.
- Use for single-day selection in scheduling or appointment flows.

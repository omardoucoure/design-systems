# DSIconSegmentedPicker

[`DSIconSegmentedPicker`](../../ios/Sources/DesignSystem/Components/DSIconSegmentedPicker.swift) is a compact segmented picker with icon-only and label+icon segments.

## Purpose

Use `DSIconSegmentedPicker` for:

- view mode toggles (grid/list)
- compact option switching with icons
- icon-based tab controls

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `[DSIconSegmentedPickerItem]` | — | Picker segments |
| `selectedId` | `Binding<String>` | — | Active segment ID |
| `width` | `CGFloat` | `145` | Total picker width |

## Data Model

```swift
DSIconSegmentedPickerItem(id: "grid", label: "Grid", icon: .grid)
DSIconSegmentedPickerItem(id: "list", icon: .list) // icon-only
```

## Example

```swift
DSIconSegmentedPicker(
    items: viewModes,
    selectedId: $mode,
    width: 160
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
- name: DSIconSegmentedPicker
  category: selection
  path: ../../ios/Sources/DesignSystem/Components/DSIconSegmentedPicker.swift
  ai_roles: [icon_tab_switcher]
```

### Key rules

- Icon-only segmented control — use when space is tight and icons communicate the options clearly without labels.
- Bind selected index to `@State`; each segment maps to a `DSIcon` enum value.
- Use `DSSegmentedPicker` instead when text labels are needed.

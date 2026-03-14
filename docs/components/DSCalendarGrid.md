# DSCalendarGrid

[`DSCalendarGrid`](../../ios/Sources/DesignSystem/Components/DSCalendarGrid.swift) is an interactive calendar grid with month navigation and range selection.

## Purpose

Use `DSCalendarGrid` for:

- date selection in booking flows
- date range pickers
- calendar views with month navigation

## Modes

- `single` — select a single date
- `range` — select a start and end date

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `displayedMonth` | `Binding<Date>` | — | Currently displayed month |
| `rangeStart` | `Binding<Date?>` | — | Selected start date |
| `rangeEnd` | `Binding<Date?>` | — | Selected end date (range mode) |
| `mode` | `DSCalendarGridMode` | `.range` | Selection mode |
| `highlightColor` | `Color?` | `nil` | Selected date color |
| `rangeColor` | `Color?` | `nil` | Range fill color |

## Example

```swift
DSCalendarGrid(
    displayedMonth: $month,
    rangeStart: $startDate,
    rangeEnd: $endDate,
    mode: .range,
    highlightColor: theme.colors.surfaceSecondary100
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
> | Component YAML | [`docs/ai/components/DSCalendarGrid.yaml`](../ai/components/DSCalendarGrid.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSCalendarGrid
  category: calendar
  path: ../../ios/Sources/DesignSystem/Components/DSCalendarGrid.swift
  variants: [single, range]
  ai_roles: [calendar_surface]
```

### Key rules

- Single or range date selection with month navigation built-in — never build a custom calendar grid.
- Use `.single` when Figma shows one date selection; `.range` for start+end selection.
- Never build custom day cells — selection state and styling are handled internally.

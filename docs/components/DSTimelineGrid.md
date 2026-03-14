# DSTimelineGrid

[`DSTimelineGrid`](../../ios/Sources/DesignSystem/Components/DSTimelineGrid.swift) is a horizontal scrollable timeline grid with tappable time columns and event slots.

## Purpose

Use `DSTimelineGrid` for:

- schedule/calendar timeline views
- hourly event grids
- time-based slot planning

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `timeLabels` | `[LocalizedStringKey]` | — | Time column headers |
| `selectedTime` | `Binding<Int>` | — | Selected time column index |
| `columnWidth` | `CGFloat` | `56` | Width of each time column |
| `slots` | `[DSTimelineSlot]` | `[]` | Event slots positioned on the grid |

## Data Model

```swift
DSTimelineSlot(
    id: "meeting",
    startHour: 9,
    row: 0,
    columnSpan: 4,
    content: { MeetingCard() }
)
```

## Example

```swift
DSTimelineGrid(
    timeLabels: ["8am", "9am", "10am", "11am", "12pm"],
    selectedTime: $selectedHour,
    slots: daySlots
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
> | Component YAML | [`docs/ai/components/DSTimelineGrid.yaml`](../ai/components/DSTimelineGrid.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSTimelineGrid
  category: calendar
  path: ../../ios/Sources/DesignSystem/Components/DSTimelineGrid.swift
  ai_roles: [schedule_grid, availability_grid]
```

### Key rules

- Scrollable time slots with offset-based event placement — never build a custom schedule grid.
- Events are positioned by their start time offset within the grid.
- Use for booking, availability, and schedule-display screens.

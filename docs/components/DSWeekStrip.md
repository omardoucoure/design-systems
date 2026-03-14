# DSWeekStrip

[`DSWeekStrip`](../../ios/Sources/DesignSystem/Components/DSWeekStrip.swift) is a horizontal scrollable week day strip with letter + number layout.

## Purpose

Use `DSWeekStrip` for:

- weekly day selectors
- calendar week views
- schedule day navigation

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `[DSWeekStripItem]` | — | Day items |
| `selectedId` | `Binding<String>` | — | Currently selected day ID |

## Data Model

```swift
DSWeekStripItem(id: "mon", letter: "M", number: "12")
```

## Example

```swift
DSWeekStrip(
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
> | Component YAML | [`docs/ai/components/DSWeekStrip.yaml`](../ai/components/DSWeekStrip.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSWeekStrip
  category: calendar
  path: ../../ios/Sources/DesignSystem/Components/DSWeekStrip.swift
  ai_roles: [compact_week_selector]
```

### Key rules

- Compact 7-day strip showing letter + number per day — tap to select; bind selected date to `@State`.
- Never build a horizontal 7-day picker manually; always use `DSWeekStrip`.
- Use above `DSDayPicker` or `DSTimelineGrid` to form a complete scheduling header.

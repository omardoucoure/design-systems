# DSDatePicker

[`DSDatePicker`](../../ios/Sources/DesignSystem/Components/DSDatePicker.swift) is a themed date picker with single and range selection modes.

## Purpose

Use `DSDatePicker` for:

- date selection modals
- booking date ranges
- scheduling interfaces

## Variants

- `single` — pick one date
- `range` — pick a start and end date

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `startDate` | `Binding<Date?>` | — | Selected start date |
| `endDate` | `Binding<Date?>` | — | Selected end date (range mode) |
| `variant` | `DSDatePickerVariant` | `.single` | Selection mode |
| `title` | `LocalizedStringKey` | `"Select date"` | Header title |
| `onCancel` | `(() -> Void)?` | `nil` | Cancel handler |
| `onConfirm` | `(() -> Void)?` | `nil` | Confirm handler |

## Example

```swift
DSDatePicker(
    startDate: $checkIn,
    endDate: $checkOut,
    variant: .range,
    title: "Select dates",
    onConfirm: { bookDates() }
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
- name: DSDatePicker
  category: calendar
  path: ../../ios/Sources/DesignSystem/Components/DSDatePicker.swift
  variants: [single, range]
  ai_roles: [date_selection, range_selection]
```

### Key rules

- Single mode returns one `Date`; range mode returns a start+end tuple — never build a custom date picker.
- Use `.single` when Figma shows one date selection; `.range` for a from/to date pair.
- Wraps `DSCalendarGrid` — use `DSDatePicker` at the page level, not `DSCalendarGrid` directly.

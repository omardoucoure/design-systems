# DSEventCard

[`DSEventCard`](../../ios/Sources/DesignSystem/Components/DSEventCard.swift) is a compact event card with title, subtitle, and trailing icon.

## Purpose

Use `DSEventCard` for:

- calendar event entries
- schedule items
- compact information cards with icon

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `LocalizedStringKey` | — | Event title |
| `subtitle` | `LocalizedStringKey` | — | Event subtitle (time, location) |
| `icon` | `DSIcon` | — | Trailing icon |
| `background` | `Color` | — | Card background color |
| `foreground` | `Color` | — | Text and icon color |

## Example

```swift
DSEventCard(
    title: "Team standup",
    subtitle: "9:00 AM - 9:30 AM",
    icon: .calendar,
    background: theme.colors.surfacePrimary100,
    foreground: theme.colors.textNeutral0_5
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
> | Component YAML | [`docs/ai/components/DSEventCard.yaml`](../ai/components/DSEventCard.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSEventCard
  category: content
  path: ../../ios/Sources/DesignSystem/Components/DSEventCard.swift
  ai_roles: [event_summary, schedule_card]
```

### Key rules

- Compact: icon + title + subtitle in a tappable row — never build event rows manually with `HStack`.
- Read icon, title, and subtitle from Figma; use `DSIcon` enum values for the icon.
- Pair with `DSDivider` between items in a list.

# DSMetricCard

[`DSMetricCard`](../../ios/Sources/DesignSystem/Components/DSMetricCard.swift) is a fitness/dashboard stat card with title, icon, value, and optional content.

## Purpose

Use `DSMetricCard` for:

- dashboard KPI displays
- fitness/health stat cards
- any metric with icon + value + unit pattern

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `LocalizedStringKey` | — | Card title |
| `icon` | `DSIcon` | — | Title row icon |
| `value` | `String?` | `nil` | Large metric value |
| `unit` | `LocalizedStringKey?` | `nil` | Unit label next to value |
| `background` | `Color` | — | Card background |
| `foreground` | `Color` | — | Text and icon color |
| `content` | `() -> Content` | — | Optional custom content below value |

## Example

```swift
DSMetricCard(
    title: "Steps",
    icon: .footprints,
    value: "8,432",
    unit: "steps",
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
> | Component YAML | [`docs/ai/components/DSMetricCard.yaml`](../ai/components/DSMetricCard.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSMetricCard
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSMetricCard.swift
  ai_roles: [dashboard_metric, summary_card]
```

### Key rules

- Icon + value + label in a card — drives data-viz dashboards; never build inline metric tiles.
- Read icon, value, label, and trend direction from Figma; use `DSIcon` enum for the icon.
- Use inside a grid or `LazyVGrid` for dashboard layouts.

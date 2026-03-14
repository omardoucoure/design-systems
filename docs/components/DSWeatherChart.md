# DSWeatherChart

[`DSWeatherChart`](../../ios/Sources/DesignSystem/Components/DSWeatherChart.swift) is a weather-style chart with thin capsule bars, value labels, and optional line overlay.

## Purpose

Use `DSWeatherChart` for:

- temperature/weather data visualization
- bar charts with value labels above each bar
- combined bar + line chart displays

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `[DSWeatherChartData]` | — | Chart data items |
| `linePoints` | `[DSLineChartPoint]` | `[]` | Optional line overlay points |
| `barColor` | `Color?` | `nil` | Default bar color |
| `barOpacity` | `Double` | `0.6` | Bar opacity |
| `highlightColor` | `Color?` | `nil` | Highlighted bar color |
| `lineColor` | `Color?` | `nil` | Line overlay color |
| `maxBarHeight` | `CGFloat` | `174` | Maximum bar height |
| `barWidth` | `CGFloat` | `8` | Bar width |

## Data Model

```swift
DSWeatherChartData(label: "Mon", value: "24°", barHeight: 80, isHighlighted: true)
```

## Example

```swift
DSWeatherChart(
    data: weekForecast,
    barColor: theme.colors.surfacePrimary100,
    highlightColor: theme.colors.surfaceSecondary100,
    maxBarHeight: 160
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
> | Component YAML | [`docs/ai/components/DSWeatherChart.yaml`](../ai/components/DSWeatherChart.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSWeatherChart
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSWeatherChart.swift
  ai_roles: [thin_capsule_bar_chart]
```

### Key rules

- Thin capsule bars designed for weather and environmental data ranges (min/max per period).
- Each bar represents a range (low to high), not a single value — pass both bounds per data point.
- Never build custom capsule-bar charts; always use `DSWeatherChart` for this pattern.

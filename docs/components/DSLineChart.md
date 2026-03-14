# DSLineChart

[`DSLineChart`](../../ios/Sources/DesignSystem/Components/DSLineChart.swift) is a smooth line chart with dampened shadow using Catmull-Rom spline interpolation.

## Purpose

Use `DSLineChart` for:

- trend visualizations
- time-series data
- smooth curved data plots

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `points` | `[DSLineChartPoint]` | — | Data points (x, y normalized 0–1) |
| `lineColor` | `Color?` | `nil` | Line stroke color |
| `shadowColor` | `Color?` | `nil` | Shadow line color |
| `lineWidth` | `CGFloat` | `2` | Main line stroke width |
| `shadowBlur` | `CGFloat` | `1.5` | Shadow blur radius |
| `shadowOpacity` | `Double` | `0.2` | Shadow opacity |
| `shadowDamping` | `Double` | `0.35` | Shadow dampening factor |
| `showShadow` | `Bool` | `true` | Toggle shadow visibility |

## Data Model

```swift
DSLineChartPoint(x: 0.0, y: 0.3)
DSLineChartPoint(x: 0.5, y: 0.8)
DSLineChartPoint(x: 1.0, y: 0.6)
```

## Example

```swift
DSLineChart(
    points: trendData,
    lineColor: theme.colors.surfaceSecondary100,
    showShadow: true
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
> | Component YAML | [`docs/ai/components/DSLineChart.yaml`](../ai/components/DSLineChart.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSLineChart
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSLineChart.swift
  ai_roles: [trend_chart]
```

### Key rules

- Uses Catmull-Rom spline interpolation for smooth curves; data points are `[Double]`.
- Never build a custom line chart with `Path` manually; always use `DSLineChart`.
- Read gradient fill and line color from Figma and map to theme color tokens.

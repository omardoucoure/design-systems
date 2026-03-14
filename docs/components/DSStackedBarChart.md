# DSStackedBarChart

[`DSStackedBarChart`](../../ios/Sources/DesignSystem/Components/DSStackedBarChart.swift) is a stacked vertical bar chart with optional time labels beneath each column.

## Purpose

Use `DSStackedBarChart` for:

- multi-category bar charts
- time-based stacked data (e.g., activity by hour)
- color-coded segment comparisons

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `columns` | `[DSStackedBarChartColumn]` | — | Chart columns |
| `timeLabels` | `[LocalizedStringKey]` | `[]` | Labels beneath columns |
| `chartHeight` | `CGFloat` | `129` | Total chart height |
| `barWidth` | `CGFloat` | `4` | Width of each bar |
| `segmentGap` | `CGFloat` | `6` | Gap between stacked segments |

## Data Models

```swift
DSStackedBarChartSegment(height: 40, color: .red)
DSStackedBarChartColumn(segments: [segment1, segment2])
```

## Example

```swift
DSStackedBarChart(
    columns: hourlyData,
    timeLabels: ["6am", "12pm", "6pm", "12am"],
    chartHeight: 150,
    barWidth: 6
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
> | Component YAML | [`docs/ai/components/DSStackedBarChart.yaml`](../ai/components/DSStackedBarChart.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSStackedBarChart
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSStackedBarChart.swift
  ai_roles: [stacked_comparison_chart]
```

### Key rules

- Time-series stacked bars with time labels below — use when Figma shows multiple series stacked per time period.
- Each data entry provides values for each series; series colors come from theme tokens.
- Never build stacked bars manually with overlapping `Rectangle` views.

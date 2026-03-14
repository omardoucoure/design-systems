# DSStatsChart

[`DSStatsChart`](../../ios/Sources/DesignSystem/Components/DSStatsChart.swift) is a chart combining pill-shaped bars, smooth line overlay, y-axis labels, and floating badge.

## Purpose

Use `DSStatsChart` for:

- complex dashboard charts with bars + trend line
- fitness/health data with highlighted values
- any chart needing both bar and line visualization

## Styles

- `light` — light background theme
- `medium` — medium toned theme
- `dark` — dark background theme
- `brand` — brand-colored theme

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `[DSStatsChartData]` | — | Bar data (label + value) |
| `linePoints` | `[DSLineChartPoint]?` | `nil` | Optional line overlay points |
| `style` | `DSStatsChartStyle` | `.light` | Color theme |
| `yLabels` | `[String]` | `["6","4","2","0"]` | Y-axis labels |
| `badgeText` | `String?` | `nil` | Floating badge text |
| `badgeX` | `CGFloat` | `0.5` | Badge X position (0–1) |
| `badgeY` | `CGFloat` | `0.5` | Badge Y position (0–1) |
| `barHeight` | `CGFloat` | `108` | Maximum bar height |
| `barWidth` | `CGFloat` | `32` | Bar width |

## Example

```swift
DSStatsChart(
    data: weeklyData,
    linePoints: trendLine,
    style: .dark,
    badgeText: "Peak",
    badgeX: 0.7,
    badgeY: 0.2
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
- name: DSStatsChart
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSStatsChart.swift
  ai_roles: [combined_bar_line_chart]
```

### Key rules

- Combined bar+line chart — the floating badge shows the current highlighted value.
- Never combine `DSBarChart` and `DSLineChart` manually; use `DSStatsChart` for this layout.
- Read bar data, line data, and badge position from Figma.

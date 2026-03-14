# DSHorizontalBarChart

[`DSHorizontalBarChart`](../../ios/Sources/DesignSystem/Components/DSHorizontalBarChart.swift) is a dual horizontal bar chart for comparing two data sets side by side.

## Purpose

Use `DSHorizontalBarChart` for:

- A/B comparisons (e.g., this week vs last week)
- dual-metric visualizations
- horizontal stat breakdowns

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `[DSHorizontalBarChartData]` | — | Chart rows |
| `leftColor` | `Color?` | `nil` | Left bar color |
| `rightColor` | `Color?` | `nil` | Right bar color |
| `rightOpacity` | `Double` | `0.75` | Right bar opacity |
| `barHeight` | `CGFloat` | `8` | Height of each bar |
| `labelWidth` | `CGFloat` | `19` | Width of center label column |

## Data Model

```swift
DSHorizontalBarChartData(label: "Mon", leftValue: 60, rightValue: 45)
```

## Example

```swift
DSHorizontalBarChart(
    data: weekComparison,
    leftColor: theme.colors.surfaceSecondary100,
    rightColor: theme.colors.surfacePrimary100
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
- name: DSHorizontalBarChart
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSHorizontalBarChart.swift
  ai_roles: [dual_bar_comparison]
```

### Key rules

- Dual horizontal comparison with left+right values per row — use when Figma shows two opposing bars per category.
- Data is array-driven; never build custom horizontal bars with `GeometryReader` and `Rectangle`.
- Read bar colors from Figma and map to theme color tokens.

# DSBarChart

[`DSBarChart`](../../ios/Sources/DesignSystem/Components/DSBarChart.swift) is a simple bar chart with rounded-top bars and labels.

## Purpose

Use `DSBarChart` for:

- simple data visualizations
- category comparisons
- highlighted bar emphasis

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `[DSBarChartData]` | — | Chart data (label + value) |
| `barColor` | `Color?` | `nil` | Default bar color |
| `highlightColor` | `Color?` | `nil` | Color for highlighted bar |
| `highlightIndex` | `Int?` | `nil` | Index of bar to highlight |
| `maxHeight` | `CGFloat` | `120` | Maximum bar height |

## Data Model

```swift
DSBarChartData(id: "mon", label: "Mon", value: 45)
```

## Example

```swift
DSBarChart(
    data: weekData,
    barColor: theme.colors.surfacePrimary100,
    highlightColor: theme.colors.surfaceSecondary100,
    highlightIndex: 2
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
- name: DSBarChart
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSBarChart.swift
  ai_roles: [simple_bar_chart]
```

### Key rules

- Data-driven; highlighting is index-based — pass the selected bar index from state.
- Never build a custom bar chart with manual `Rectangle` views; always use `DSBarChart`.
- Read bar colors and axis labels directly from Figma data.

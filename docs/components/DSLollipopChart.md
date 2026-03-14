# DSLollipopChart

[`DSLollipopChart`](../../ios/Sources/DesignSystem/Components/DSLollipopChart.swift) is a circle-top bar chart with rotated month labels.

## Purpose

Use `DSLollipopChart` for:

- monthly data overviews
- bar charts with circular value markers
- charts with highlighted data points and value labels

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `[DSLollipopChartItem]` | — | Chart items |
| `highlightIndex` | `Int?` | `nil` | Index to highlight |
| `highlightLabel` | `String?` | `nil` | Label shown above highlighted item |
| `color` | `Color?` | `nil` | Bar and circle color |

## Data Model

```swift
DSLollipopChartItem(label: "Jan", height: 60)
```

## Example

```swift
DSLollipopChart(
    data: monthlyData,
    highlightIndex: 5,
    highlightLabel: "120",
    color: theme.colors.surfacePrimary100
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
- name: DSLollipopChart
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSLollipopChart.swift
  ai_roles: [lightweight_comparison_chart]
```

### Key rules

- Lightweight alternative to bar chart with rotated labels — use when Figma shows lollipop-style data points.
- Never build a custom lollipop chart with `Path` + `Circle`; always use `DSLollipopChart`.
- Data is array-driven; dot color and stem color come from theme tokens.

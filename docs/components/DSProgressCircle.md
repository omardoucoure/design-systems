# DSProgressCircle

[`DSProgressCircle`](../../ios/Sources/DesignSystem/Components/DSProgressCircle.swift) is a themed circular progress indicator with percentage label.

## Purpose

Use `DSProgressCircle` for:

- task/goal completion indicators
- loading progress displays
- fitness/health progress rings

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `progress` | `Double` | — | Progress value (0.0–1.0) |
| `size` | `CGFloat` | `40` | Circle diameter |
| `lineWidth` | `CGFloat` | `8.6` | Progress arc stroke width |
| `trackLineWidth` | `CGFloat?` | `nil` | Background track stroke width |
| `customLabel` | `String?` | `nil` | Custom center label (overrides %) |
| `trackColor` | `Color?` | `nil` | Background track color |
| `progressColor` | `Color?` | `nil` | Progress arc color |
| `labelColor` | `Color?` | `nil` | Center label color |

## Example

```swift
DSProgressCircle(progress: 0.72, size: 80, lineWidth: 10)
DSProgressCircle(
    progress: 0.45,
    size: 120,
    customLabel: "45%",
    progressColor: theme.colors.surfaceSecondary100
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
> | Component YAML | [`docs/ai/components/DSProgressCircle.yaml`](../ai/components/DSProgressCircle.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSProgressCircle
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSProgressCircle.swift
  ai_roles: [progress_indicator, radial_metric]
```

### Key rules

- Use `customLabel` closure for rich center content (multi-line text, icons).
- `progressColor` and `labelColor` default to theme colors if not provided — only override when Figma specifies a different color.
- Never build a custom circular progress with `Circle().trim()` manually.

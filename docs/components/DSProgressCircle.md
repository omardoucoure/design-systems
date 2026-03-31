# DSProgressCircle

[`DSProgressCircle`](../../ios/Sources/DesignSystem/Components/DSProgressCircle.swift) is a themed circular progress indicator with percentage label.

## Purpose

Use `DSProgressCircle` for:

- task/goal completion indicators
- loading progress displays
- fitness/health progress rings

## Init

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `progress` | `Double` | — | Progress value (0.0–1.0) |

## Modifiers

| Modifier | Type | Default | Description |
|----------|------|---------|-------------|
| `.circleSize(_:)` | `CGFloat` | `40` | Circle diameter |
| `.lineWidth(_:)` | `CGFloat` | `8.6` | Progress arc stroke width |
| `.trackLineWidth(_:)` | `CGFloat` | `1` | Background track stroke width |
| `.customLabel(_:)` | `String` | percentage | Custom center label (overrides %) |
| `.trackColor(_:)` | `Color` | `surfaceNeutral3` | Background track color |
| `.progressColor(_:)` | `Color` | `surfaceSecondary100` | Progress arc color |
| `.labelColor(_:)` | `Color` | `textNeutral9 @ 75%` | Center label color |

## Example

```swift
DSProgressCircle(progress: 0.72)
    .circleSize(80)
    .lineWidth(10)

DSProgressCircle(progress: 0.45)
    .circleSize(120)
    .customLabel("45%")
    .progressColor(theme.colors.surfaceSecondary100)
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

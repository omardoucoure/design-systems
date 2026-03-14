# DSSemiCircularGauge

[`DSSemiCircularGauge`](../../ios/Sources/DesignSystem/Components/DSSemiCircularGauge.swift) is a semi-circular gauge with thick arc segments, perimeter dots, and a content slot.

## Purpose

Use `DSSemiCircularGauge` for:

- health/fitness score gauges
- multi-segment progress arcs
- dashboard dials with center content

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `segments` | `[DSSemiCircularGaugeSegment]` | — | Arc segments |
| `dotCount` | `Int` | `9` | Number of perimeter dots |
| `dotRadius` | `CGFloat` | `2.5` | Dot radius |
| `dotColor` | `Color?` | `nil` | Dot color |
| `strokeWidth` | `CGFloat` | `14` | Arc stroke width |
| `gapDegrees` | `Double` | `4` | Gap between segments |
| `content` | `() -> Content` | — | Center content view |

## Data Model

```swift
DSSemiCircularGaugeSegment(fraction: 0.4, color: .green)
DSSemiCircularGaugeSegment(fraction: 0.3, color: .yellow)
DSSemiCircularGaugeSegment(fraction: 0.3, color: .red)
```

## Example

```swift
DSSemiCircularGauge(segments: healthSegments, strokeWidth: 16) {
    VStack {
        Text("72").font(theme.typography.h2.font)
        Text("Good").font(theme.typography.caption.font)
    }
}
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
- name: DSSemiCircularGauge
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSSemiCircularGauge.swift
  ai_roles: [gauge, score_summary]
```

### Key rules

- Arc-based score display; segments and value are data-driven — never build a custom arc gauge with `Path`.
- Read segment colors, current value, and max value from Figma.
- Use for score summaries and health/performance gauges.

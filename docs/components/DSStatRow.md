# DSStatRow

[`DSStatRow`](../../ios/Sources/DesignSystem/Components/DSStatRow.swift) is a row of equal-width stat columns with vertical dividers.

## Purpose

Use `DSStatRow` for:

- profile stat summaries (followers, posts, likes)
- dashboard metric rows
- any side-by-side stat comparison

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `[DSStatItem]` | — | Stat items (label only) |
| `dividerColor` | `Color?` | `nil` | Vertical divider color |
| `valueContent` | `(DSStatItem) -> ValueContent` | — | Custom view for each stat value |

## Data Model

```swift
DSStatItem(id: "followers", label: "Followers")
```

## Example

```swift
DSStatRow(items: stats) { item in
    Text(statValues[item.id] ?? "0")
        .font(theme.typography.h4.font)
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
- name: DSStatRow
  category: data_viz
  path: ../../ios/Sources/DesignSystem/Components/DSStatRow.swift
  ai_roles: [equal_width_stats, summary_strip]
```

### Key rules

- Columns are automatically equal-width — use for summary strips of 2–4 stats.
- Never build a stats row with a manual `HStack` + `Spacer`; always use `DSStatRow`.
- Each stat takes a value string and a label string; read both from Figma.

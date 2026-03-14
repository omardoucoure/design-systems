# DSBottomAppBar

[`DSBottomAppBar`](../../ios/Sources/DesignSystem/Components/DSBottomAppBar.swift) is a themed bottom navigation bar with icon tabs and optional FAB.

## Purpose

Use `DSBottomAppBar` for:

- primary app navigation
- tab switching with icon indicators
- floating action button placement

## Styles

- `full` — full-width bar anchored to bottom
- `floating` — rounded floating pill bar
- `labeled` — tabs with icon + text label

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `[DSBottomBarItem]` | — | Navigation items |
| `selectedId` | `Binding<String>` | — | Active tab ID |
| `style` | `DSBottomAppBarStyle` | `.labeled` | Visual style |
| `fabIcon` | `String?` / `DSIcon?` | `nil` | FAB icon (SF Symbol or DSIcon) |
| `fabColor` | `Color?` | `nil` | FAB background color |
| `fabForegroundColor` | `Color?` | `nil` | FAB icon color |
| `fabBadgeCount` | `Int?` | `nil` | Badge count on FAB |
| `onFabTap` | `(() -> Void)?` | `nil` | FAB tap handler |
| `embedded` | `Bool` | `false` | Embed inside another container |

## Data Model

```swift
DSBottomBarItem(id: "home", label: "Home", systemIcon: "house")
DSBottomBarItem(id: "feed", label: "Feed", icon: .feed)
```

## Example

```swift
DSBottomAppBar(
    items: tabs,
    selectedId: $selectedTab,
    style: .floating,
    fabIcon: "plus",
    onFabTap: { createNew() }
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
> | Component YAML | [`docs/ai/components/DSBottomAppBar.yaml`](../ai/components/DSBottomAppBar.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSBottomAppBar
  category: navigation
  path: ../../ios/Sources/DesignSystem/Components/DSBottomAppBar.swift
  variants: [full, floating, labeled]
  ai_roles: [bottom_navigation, fab_navigation]
```

### Key rules

- Always use inside `DSTabView` for tab navigation — never place standalone.
- Floating style needs `.padding(.horizontal)` and `.padding(.bottom)` from the enclosing `ZStack`.
- Use `ZStack(alignment: .bottom)` to layer the floating bar over scrollable content, and add `.padding(.bottom, 100)` inside the `ScrollView` content to prevent overlap.

# DSBottomNavOverlay

[`DSBottomNavOverlay`](../../ios/Sources/DesignSystem/Components/DSBottomNavOverlay.swift) is a full-screen bottom navigation overlay with pill-shaped menu buttons.

## Purpose

Use `DSBottomNavOverlay` for:

- expanded navigation menus
- full-screen menu overlays with close button
- alternative navigation patterns

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isPresented` | `Binding<Bool>` | — | Controls visibility |
| `items` | `[DSBottomNavOverlayItem]` | — | Menu items |
| `onItemTap` | `((DSBottomNavOverlayItem) -> Void)?` | `nil` | Item selection handler |

## Data Model

```swift
DSBottomNavOverlayItem(id: "settings", label: "Settings")
```

## Example

```swift
DSBottomNavOverlay(
    isPresented: $showNav,
    items: menuItems,
    onItemTap: { item in navigate(to: item.id) }
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
> | Component YAML | [`docs/ai/components/DSBottomNavOverlay.yaml`](../ai/components/DSBottomNavOverlay.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSBottomNavOverlay
  category: navigation
  path: ../../ios/Sources/DesignSystem/Components/DSBottomNavOverlay.swift
  ai_roles: [fullscreen_nav_overlay]
```

### Key rules

- Full-screen nav overlay with slide-up animation — for deep nav menus, not inline content.
- Present via a `@State` boolean toggle; never place it statically in the view hierarchy.
- Use for secondary navigation that cannot fit in the bottom app bar.

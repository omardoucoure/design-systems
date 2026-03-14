# DSSideMenuLayout

[`DSSideMenuLayout`](../../ios/Sources/DesignSystem/Components/DSSideMenuLayout.swift) is a container wrapping page content with a slide-out side drawer menu.

## Purpose

Use `DSSideMenuLayout` for:

- pages with hamburger menu navigation
- side drawer patterns
- content that scales down when the menu opens

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isOpen` | `Binding<Bool>` | — | Menu open state |
| `menuWidth` | `CGFloat` | `260` | Drawer width |
| `contentScale` | `CGFloat` | `0.85` | Content scale when menu is open |
| `showBackgroundCards` | `Bool` | `true` | Show ghost card layering effect |
| `menu` | `() -> Menu` | — | Menu content view |
| `content` | `() -> Content` | — | Page content view |

## Example

```swift
DSSideMenuLayout(isOpen: $menuOpen) {
    DSNavigationMenu(items: menuItems, onSelect: { item in
        navigate(to: item.id)
        menuOpen = false
    })
} content: {
    MainPageContent()
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
- name: DSSideMenuLayout
  category: navigation
  path: ../../ios/Sources/DesignSystem/Components/DSSideMenuLayout.swift
  ai_roles: [side_drawer_layout]
```

### Key rules

- The `content:` closure is the main page content; the first closure is the side menu (use `DSNavigationMenu` there).
- Apply the same `ZStack(alignment: .bottom)` floating element pattern inside the `content:` closure.
- Never build a custom slide-out drawer with `offset` and `DragGesture`; always use `DSSideMenuLayout`.

# DSNavigationMenu

[`DSNavigationMenu`](../../ios/Sources/DesignSystem/Components/DSNavigationMenu.swift) is a side navigation menu with icon+label rows and optional profile section.

## Purpose

Use `DSNavigationMenu` for:

- side drawer menu content
- vertical navigation lists
- menus with profile header

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `[DSNavigationMenuItem]` | — | Menu items |
| `profile` | `DSNavigationMenuProfile?` | `nil` | Optional profile row at top |
| `onSelect` | `((DSNavigationMenuItem) -> Void)?` | `nil` | Item selection handler |

## Data Models

```swift
DSNavigationMenuItem(id: "home", label: "Home", icon: .home, isSelected: true)
DSNavigationMenuProfile(image: Image("avatar"), name: "Omar", subtitle: "Premium")
```

## Example

```swift
DSNavigationMenu(
    items: menuItems,
    profile: userProfile,
    onSelect: { item in navigate(to: item.id) }
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
> | Component YAML | [`docs/ai/components/DSNavigationMenu.yaml`](../ai/components/DSNavigationMenu.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSNavigationMenu
  category: navigation
  path: ../../ios/Sources/DesignSystem/Components/DSNavigationMenu.swift
  ai_roles: [side_menu_content]
```

### Key rules

- Always used inside `DSSideMenuLayout` — never placed standalone in a view hierarchy.
- Provides the content of the side drawer (user info, menu items, footer actions).
- Menu items are data-driven; pass an array of `DSNavigationMenuItem` structs.

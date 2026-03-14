# DSTabView

[`DSTabView`](../../ios/Sources/DesignSystem/Components/DSTabView.swift) is a tab view container with DSBottomAppBar integration.

## Purpose

Use `DSTabView` for:

- top-level app navigation with bottom tabs
- tab-based page switching
- replacing SwiftUI's native TabView with themed styling

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `selection` | `Binding<String>` | — | Active tab ID |
| `tabs` | `[DSBottomBarItem]` | — | Tab definitions |
| `style` | `DSBottomAppBarStyle` | `.labeled` | Bottom bar style |
| `content` | `(String) -> Content` | — | Content builder per tab ID |

## Related

- `DSTabBarVisibility` — observable object to show/hide the tab bar from child views
- `.dsTabBarHidden(true)` — view modifier to hide the tab bar

## Example

```swift
DSTabView(selection: $activeTab, tabs: appTabs, style: .labeled) { tabId in
    switch tabId {
    case "home": HomePage()
    case "profile": ProfilePage()
    default: EmptyView()
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
- name: DSTabView
  category: navigation
  path: ../../ios/Sources/DesignSystem/Components/DSTabView.swift
  ai_roles: [multi_tab_shell]
```

### Key rules

- Always wrap multi-tab pages in `DSTabView`; never switch tabs with `NavigationStack` or conditional rendering.
- Use a `ZStack` + opacity pattern inside the `content:` closure to keep all tabs alive simultaneously.
- Pair with `DSBottomAppBar` for the tab bar; the bar lives inside `DSTabView`.

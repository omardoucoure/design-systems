# DSTopAppBar

[`DSTopAppBar`](../../ios/Sources/DesignSystem/Components/DSTopAppBar.swift) is a themed top navigation bar with multiple layout styles.

## Background & Blur

`DSTopAppBar` uses **`ultraThinMaterial`** as its background — it is always transparent with a system blur. There is no opaque background. A 24pt progressive gradient fade extends below the bar, matching the iOS 26 scroll-edge effect where content softly dissolves as it scrolls under the bar.

**Consequence for page layout:** Because the bar is transparent, page background color shows through. Always set `.background(theme.colors.surfaceNeutral0_5)` (or your page background) on the outermost container, not on the top bar itself.

## Purpose

Use `DSTopAppBar` for:

- page headers with back button
- centered title bars
- logo-based headers
- search-ready top bars

## Styles

- `small` — left-aligned title with optional back button
- `smallCentered` — centered title with optional back button
- `medium` — larger title
- `large` — prominent title
- `logo` — custom center content with leading icon
- `search` — search bar layout with leading icon
- `imageTitle` — title with leading image

## Properties (standard init)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `LocalizedStringKey` | — | Bar title |
| `style` | `DSTopAppBarStyle` | `.small` | Layout style |
| `onBack` | `(() -> Void)?` | `nil` | Back button handler |
| `actions` | `() -> Actions` | — | Trailing action buttons |

## Example

```swift
DSTopAppBar(title: "Settings", style: .smallCentered, onBack: { dismiss() }) {
    DSButton(style: .neutral, size: .medium, icon: .menuScale) {}
}

DSTopAppBar(
    searchPlaceholder: "Search...",
    onSearchTap: { showSearch() },
    leadingIcon: "line.3.horizontal",
    onLeadingTap: { openMenu() }
) {
    DSButton(style: .neutral, size: .medium, systemIcon: "bell") {}
}
```

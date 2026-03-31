# Design System Rules — Figma MCP Integration

## Token Definitions

Tokens are defined in Swift and mirrored as Figma Variables:

- **Colors**: `ios/Sources/DesignSystem/Theme/Brand.swift` — 4 brands (Coral Camo, Sea Lime, Misty Rose, Blue Haze), each with primary (80/100/120), secondary (10/40/100/120), and neutral (0-10) scales
- **Spacing**: `ios/Sources/DesignSystem/Tokens/SpacingTokens.swift` — none(0), xxxs(2), xxs(4), xs(8), sm(12), md(16), lg(24), xl(32), xxl(40), xxxl(48), xxxxl(64)
- **Radius**: `ios/Sources/DesignSystem/Tokens/RadiusTokens.swift` — Rounded mode: none(0), xxs(4), xs(8), sm(12), md(16), lg(24), xl(32), xxl(40), xxxl(64), full(360)
- **Typography**: `ios/Sources/DesignSystem/Tokens/TypographyTokens.swift` — Font: DM Sans. Styles: display1(56), display2(48), h1(40), h2(36), h3(32), h4(24), h5(20), h6(18), bodySemiBold(16), body(16), caption(14), small(12), tiny(11)
- **Border**: `ios/Sources/DesignSystem/Tokens/BorderTokens.swift` — widthNone(0), widthSm(1), widthMd(2), widthLg(4)
- **Opacity**: `ios/Sources/DesignSystem/Tokens/OpacityTokens.swift` — none(0), sm(0.25), md(0.50), lg(0.75), full(1.0)

Figma Variables: 6 collections (Spacing, Radius, Brand Colors with 4 modes, Typography, Border, Opacity) with 66 total variables.

## Component Library

Components are in `ios/Sources/DesignSystem/Components/` (55 Swift files).

Figma file key: `NzMUKWSRFEXmcH0uN5wjBC`
Figma Components page: 21 Component Sets imported from HaHo with proper variant properties.

### Figma-to-Swift Component Mapping

| Figma Component Set | Swift Component | Key Properties |
|---|---|---|
| Button | DSButton | Style (6), Size (3), State (3), Icon Left/Right, Text |
| Inputs-Filled | DSTextField (.filled) | State (7), Icon Left/Right, Helper Text, Button, Label |
| Inputs-Lined | DSTextField (.lined) | Same as Filled with bottom-border style |
| Checkbox | DSCheckbox | State: False/Selected |
| Radio | DSRadio | Selected: False/True |
| Toggle | DSToggle | Selected: False/True |
| Top App Bar | DSTopAppBar | Style (10), trailing icon toggles |
| Bottom App Bar | DSBottomAppBar | Style: Floating/Full/More Labels |
| Segmented Picker | DSSegmentedPicker | Style: Pills/Navigation Tabs |
| Page-Controls | DSPageControl | Bubbles (2-5), Active position |
| List | DSListItem | Overline, Supporting Text, Leading/Trailing Item, Metadata, Divider |
| Avatar | DSAvatar | Style: Monogram/Icon/Image |
| Progress-Circle | DSProgressCircle | Percent (10-100) |
| Divider | DSDivider | Style: Full-bleed/Inset/Middle/Subheader |
| Badges-Tags | DSBadge / DSChip | Dot, Number, Tag variants |
| Tooltip | DSTooltip | Style (2), Direction (4) |

### Component Decision Rules

When designing a page, use this decision tree:

- **User taps to do something** → Button
- **User enters text** → Inputs-Filled (most cases) or Inputs-Lined (minimal style)
- **User picks one from many** → Radio
- **User picks multiple from many** → Checkbox
- **User toggles on/off** → Toggle
- **Screen needs a title bar** → Top App Bar
- **App needs tab navigation** → Bottom App Bar
- **Switch between views on same screen** → Segmented Picker
- **Show a list of items** → List (with Leading/Trailing Items)
- **Show user identity** → Avatar
- **Show loading/progress** → Progress-Circle
- **Separate content sections** → Divider
- **Label/status indicator** → Badges-Tags
- **Pagination dots** → Page-Controls
- **Contextual hint** → Tooltip

## Icon System

- **1364 icons** in `ios/Sources/DesignSystem/Resources/Icons.xcassets/`
- All icons are 24×24 SVG with `viewBox="0 0 24 24"`
- Organized in 42 categories on the Figma Icons page
- Swift enum: `DSIcon` (1364 cases) in `DSIcon.swift`
- Rendered via: `DSIconImage(.iconName, size: 24, color: theme.colors.textNeutral9)`
- For buttons: `DSButton(style: .neutral, size: .medium, icon: .arrowLeft) { }`

## Styling Approach

- **Theme access**: `@Environment(\.theme) private var theme`
- **Colors**: `theme.colors.surfacePrimary100`, `theme.colors.textNeutral9`
- **Spacing**: `theme.spacing.md` (16px)
- **Typography**: `theme.typography.bodySemiBold.font`
- **Radius**: `theme.radius.xl` (32px)
- **NEVER hardcode** colors, fonts, spacing, or radius values

## Project Structure

```
ios/Sources/DesignSystem/
├── Components/         # 55 DS components (DSButton.swift, etc.)
├── Theme/              # Brand.swift, DesignSystem.swift
├── Tokens/             # SpacingTokens, RadiusTokens, etc.
└── Resources/
    └── Icons.xcassets/ # 1364 icon SVGs

ios/VitrineApp/         # Showcase app
docs/ai/components/     # Per-component YAML reference
scripts/
├── sync-figma-tokens.mjs  # Swift ↔ Figma sync
└── import-figma-icons.mjs # Icon import script
```

## Key Rules for AI

1. **Component-first**: Every visual element must be a DS component, never raw SwiftUI
2. **Zero hardcoding**: All values come from theme tokens
3. **Read Figma context**: Extract every CSS variable from `get_design_context` output before coding
4. **Match states**: If Figma shows dots (••••) → isSecure: true, checked checkbox → true, specific border color → specific state
5. **No bottom bar in pages**: App already has tab navigation in ContentView — pages only contain their own content
6. **iOS 16 target**: No iOS 17+ APIs

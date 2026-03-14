# Design System — Project Instructions

## ZERO-HALLUCINATION POLICY (CRITICAL — READ FIRST)

**NEVER guess, assume, or hallucinate ANY design value.** Every single property must be read directly from the Figma design context output. If you cannot find a value in the Figma data, ASK — do not invent it.

### What "no hallucination" means concretely:

- **DO NOT** guess which typography token to use — read the exact `font-size`, `font-weight` from Figma and map to the correct token (h2=36, h4=24, h5=20, bodySemiBold=16/600, body=16/500, bodyRegular=16/400, caption=14, small=12)
- **DO NOT** guess button styles — read the background color from Figma (`surfaceSecondary100` = `.filledA`, `surfacePrimary100` = `.filledB`, `surfacePrimary120` = `.filledC`, `surfaceNeutral2` = `.neutral`)
- **DO NOT** guess spacing/padding — read `gap`, `px`, `py`, `pt`, `pb`, `pl`, `pr` from Figma and map to exact spacing tokens (xxs=4, xs=8, sm=12, md=16, lg=24, xl=32, xxl=40, xxxl=48, xxxxl=64)
- **DO NOT** guess component states — read the actual Figma content (dots `••••` = secure/password field, checked checkbox = `true` state, specific border color = specific state)
- **DO NOT** guess overlap/margin values — read `mb-[-50px]` from Figma, use exactly `-50`
- **DO NOT** invent initial state — if Figma shows a checkbox checked, initialize it as `true`

### Common hallucination mistakes to NEVER repeat:

1. **Password fields**: If Figma text shows `••••••••`, use `isSecure: true` on DSTextField — NEVER show plaintext
2. **Asymmetric padding**: When Figma shows `px=32, py=40`, do NOT use a single uniform `padding: 32` — use `padding: 0` on DSCard and apply `.padding(.horizontal, 32).padding(.vertical, 40)` manually
3. **Navigation bar**: If Figma has NO back button, add `.toolbar(.hidden, for: .navigationBar)` — ALWAYS check this for every page
4. **Button style mapping**: Read the actual background color hex from Figma, map it to the correct style enum — NEVER default to `.neutral` without checking
5. **Spacing values**: Read the exact `py`, `gap` values — do NOT substitute `xxs` (4) when Figma says `xs` (8)
6. **Images**: NEVER reuse existing placeholder images if Figma provides different ones — ALWAYS download images from the Figma asset URLs (`curl -sL "https://www.figma.com/api/mcp/asset/..."`) and create proper asset catalog entries (`.imageset/` with `Contents.json`)
7. **Icons**: NEVER substitute SF Symbols when Figma provides custom vector icons — download SVG assets from Figma and add them to the asset catalog with `preserves-vector-representation: true`. Use `DSButton(assetIcon:)` for custom icon buttons
8. **Every Figma property must be used**: Do NOT skip opacity values, exact icon names, z-index ordering, negative margins, or any CSS variable from the design context. Read EVERY line of the Figma output and map it to code

### Mandatory extraction checklist (before writing ANY page):

For each element in the Figma design context output, extract:
- [ ] `font-*` → typography token
- [ ] `bg-[var(--surface/*)]` → color token
- [ ] `text-[color:var(--text/*)]` → text color token
- [ ] `border-*` → border color + width
- [ ] `gap-[var(--spacing/*)]` → spacing token
- [ ] `px-*`, `py-*`, `pt-*`, `pb-*` → padding (check for asymmetry!)
- [ ] `rounded-[var(--radius/*)]` → radius token
- [ ] `h-[*px]`, `w-[*px]` → fixed dimensions
- [ ] `opacity-*` → opacity values
- [ ] `mb-[-*px]` → negative margins for overlaps
- [ ] Text content (dots = secure, checked = true, specific icon names)

## How to Read Figma Design Context Output

The `get_design_context` tool returns React+Tailwind code with CSS variables that map to our design tokens:

### Token mapping reference:

| Figma CSS Variable | Swift Token |
|---|---|
| `var(--spacing/spacing-sm-(12),12px)` | `theme.spacing.sm` |
| `var(--spacing/spacing-lg-(24),24px)` | `theme.spacing.lg` |
| `var(--spacing/spacing-xl-(32),32px)` | `theme.spacing.xl` |
| `var(--spacing/spacing-xxl-(40),40px)` | `theme.spacing.xxl` |
| `var(--spacing/spacing-xxxxl-(64),64px)` | `theme.spacing.xxxxl` |
| `var(--surface/surface-neutral-(2),#ebebe6)` | `theme.colors.surfaceNeutral2` |
| `var(--surface/surface-primary-(100),#465a54)` | `theme.colors.surfacePrimary100` |
| `var(--surface/surface-secondary-(100),#ff6a5f)` | `theme.colors.surfaceSecondary100` |
| `var(--text/text-neutral-(9),#292927)` | `theme.colors.textNeutral9` |
| `var(--text/text-neutral-(0,5),#fafaf9)` | `theme.colors.textNeutral0_5` |
| `var(--border/border-neutral-(2),#ebebe6)` | `theme.colors.borderNeutral2` |
| `var(--radius/radius-xl-(32),32px)` | `theme.radius.xl` |
| `var(--radius/radius-mg-(16),16px)` | `theme.radius.md` |
| `font-semibold text-[16px]` | `theme.typography.bodySemiBold` |
| `font-medium text-[16px]` | `theme.typography.body` |
| `font-normal text-[16px]` | `theme.typography.bodyRegular` |
| `font-medium text-[24px]` | `theme.typography.h4` |
| `font-medium text-[20px]` | `theme.typography.h5` |
| `font-medium text-[36px]` | `theme.typography.h2` |
| `font-medium text-[14px]` | `theme.typography.caption` |
| `font-medium text-[12px]` | `theme.typography.small` |

### Reading padding from Figma output:

When you see: `px-[var(--spacing/spacing-xl-(32),32px)] py-[var(--spacing/spacing-xxl-(40),40px)]`
- This means: horizontal padding = `xl` (32), vertical padding = `xxl` (40)
- Since DSCard only accepts a single `padding` parameter, use `padding: 0` and apply manually:
```swift
DSCard(background: ..., radius: ..., padding: 0) {
    content
        .padding(.horizontal, theme.spacing.xl)
        .padding(.vertical, theme.spacing.xxl)
}
```

### Reading overlapping cards:

When you see: `mb-[-50px]` on a card
- This means the NEXT card overlaps this one by 50px
- Implement with `.padding(.top, -50)` on the next card in the VStack

When a card has large top padding (e.g., `pt-[64px]`), this is to compensate for overlap from the card above.

## Component-First Architecture

**Every visual element on a page MUST be a DS component.** Pages should be simple compositions of components.

### Rules:
1. **If a pattern appears in a Figma design, it must be a reusable component** — not inline SwiftUI in the page file
2. **If a component doesn't exist yet, create it** in `ios/Sources/DesignSystem/Components/` before using it in a page
3. **Pages must be thin** — only composition logic (VStack/HStack/ZStack of DS components), state management (@State), and navigation
4. **No raw styling in pages** — colors, fonts, spacing, radius should come from components or theme tokens
5. **Always use DSCard as container** — never build raw containers with `.background().clipShape()` in pages

### NEVER DO THIS — Common violations:
- ❌ `RoundedRectangle(cornerRadius: ...).fill(color)` → ✅ `DSCard(background: color, radius: theme.radius.xl, padding: 0) { Color.clear }`
- ❌ `Button { } label: { Text("...") }` → ✅ `DSButton("...", style: .text, size: .medium) { }`
- ❌ `.font(.system(size: 20))` or `.font(.custom("DMSans-...", size: 14))` → ✅ `theme.typography.caption.font`
- ❌ Custom back-button ZStack with DSButton + Text → ✅ `DSTopAppBar(title: "...", style: .small, onBack: { dismiss() })`
- ❌ `.foregroundStyle(.black)` or `.foregroundStyle(Color(hex: ...))` → ✅ `theme.colors.textNeutral9`
- ❌ `VStack(spacing: 2)` or `padding(50)` → ✅ `theme.spacing.xxs`, `theme.spacing.xxxl`
- ❌ `.frame(width: 12, height: 12)` → ✅ `.frame(width: theme.spacing.sm, height: theme.spacing.sm)`
- ❌ `.bold()` modifier on top of typography token → remove; token already encodes weight
- ❌ `Image(...).resizable().clipShape(Circle())` for avatars → ✅ `DSAvatar(style: .image(...), size: 40)`

### Component Design Principles:
- Components are **highly customizable via properties** — changing a property changes the state/appearance
- Use enums for variants/styles/states (e.g., `InputState.error`, `DSButtonStyle.filledA`)
- Accept `LocalizedStringKey` for all user-facing text
- Access theme via `@Environment(\.theme) private var theme`
- All tokens come from the theme, never hardcoded values

### Available DS Components:
- `DSButton` — styles: `.filledA`, `.filledB`, `.filledC`, `.neutral`, `.outlined`, `.text` / supports SF Symbols via `systemIcon:` and custom asset images via `assetIcon:` / text+asset icon via `init(_:style:size:assetIcon:iconPosition:)`
- `DSTextField` — variants: `.filled`, `.lined` / states: `.empty`, `.filled`, `.active`, `.error`, `.validated` / supports `isSecure: true` for password fields
- `DSCard` — container with `background`, `radius`, `padding` (use `padding: 0` for asymmetric padding)
- `DSCheckbox` — toggle with label
- `DSCodeInput` — OTP/verification code input (interactive, numeric keyboard)
- `DSListItem` — list row with `overline`, `headline`, `metadata`, generic leading/trailing slots
- `DSDivider` — styles: `.fullBleed`, `.inset`, `.middle`, `.subheader(...)`
- `DSProgressCircle` — circular progress indicator; supports `customLabel`, `progressColor`, `labelColor`
- `DSCarousel` — horizontal image carousel; styles: `.spotlight` (zoom focus), `.standard` (flat)
- `DSUserCard` — profile card with avatar, name, bio, stat, and sign-out/edit actions
- `DSChip`, `DSBadge`, `DSAvatar`, `DSToggle`, `DSRadio`, `DSDropdown`, `DSSearchField`, `DSTextArea`, `DSTooltip`, `DSTopAppBar`, `DSBottomAppBar`, `DSSegmentedPicker`, `DSDatePicker`, `DSPageControl`

### Typography quick reference (NEVER use .font(.system(...)) or .font(.custom(...))):
| Size | Weight | Token |
|---|---|---|
| 36px medium | `theme.typography.h2` |
| 24px medium | `theme.typography.h4` |
| 20px medium | `theme.typography.h5` |
| 18px medium | `theme.typography.h6` |
| 18px semibold | `theme.typography.largeSemiBold` |
| 16px semibold | `theme.typography.bodySemiBold` |
| 16px medium | `theme.typography.body` |
| 16px regular | `theme.typography.bodyRegular` |
| 14px semibold | `theme.typography.label` |
| 14px medium | `theme.typography.caption` |
| 12px medium | `theme.typography.small` |
| 12px regular | `theme.typography.smallRegular` |

### Page Implementation Checklist:
1. **Fetch Figma context** — `get_design_context` for the node
2. **Inventory all elements** — map each to a DS component
3. **Extract ALL properties** from the Figma output (see extraction checklist above)
4. **Create missing components** if needed
5. **Compose the page** using only DS components and theme tokens
6. **Add `.toolbar(.hidden, for: .navigationBar)`** if the Figma design has no native navigation bar
7. **Verify against Figma screenshot** after building

### Page Layout Pattern — ScrollView with floating bottom elements (CRITICAL):

Most pages follow this structure: a top app bar pinned at the top, scrollable content in the middle, and a floating element (bottom app bar, FAB button) at the bottom. **Always** use this pattern:

```swift
var body: some View {
    ZStack(alignment: .bottom) {
        VStack(spacing: 0) {
            // 1. Top app bar — pinned, never scrolls
            DSTopAppBar(title: "Title", style: .smallCentered, onBack: { dismiss() }) {
                DSButton(style: .neutral, size: .medium, icon: .menuScale) {}
            }

            // 2. ScrollView — fills remaining space, NO outer horizontal padding
            ScrollView {
                VStack(spacing: theme.spacing.sm) {
                    // Content goes here
                }
                // Horizontal padding goes INSIDE the ScrollView as content inset
                .padding(.horizontal, theme.spacing.sm)
                // Bottom padding to clear the floating element
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
        }

        // 3. Floating element — overlays at the bottom
        DSBottomAppBar(items: items, selectedId: $tab, style: .floating)
            .padding(.horizontal, theme.spacing.md)
            .padding(.bottom, theme.spacing.lg)
    }
    .background(theme.colors.surfaceNeutral0_5)
}
```

**Key rules:**
- ❌ **NEVER** put `.padding(.horizontal)` on the outer VStack — it clips the ScrollView edges
- ❌ **NEVER** use `Spacer()` to push content above a floating element — use `.padding(.bottom, 100)` inside ScrollView
- ✅ **ALWAYS** put horizontal padding INSIDE the ScrollView on the content VStack (`.padding(.horizontal, theme.spacing.sm)`)
- ✅ **ALWAYS** add `.padding(.bottom, 100)` (or appropriate value) inside ScrollView content to prevent overlap with floating elements
- ✅ **ALWAYS** use `ZStack(alignment: .bottom)` to layer floating elements over the ScrollView
- ✅ The VStack wrapping top bar + ScrollView uses `spacing: 0` — gaps between top bar and content come from content padding, not VStack spacing
- For pages with `DSSideMenuLayout`, the same pattern applies inside the `content:` closure

## Theming System

### Applying the theme (app entry point)

```swift
// Standard — uses a built-in brand palette
ContentView()
    .designSystem(brand: .coralCamo, style: .lightRounded)

// With custom brand colors — overrides primary and/or secondary everywhere
ContentView()
    .designSystem(
        brand: .coralCamo,          // neutral scale comes from the brand
        style: .lightRounded,
        primaryColor: Color(hex: "#1A73E8"),
        secondaryColor: Color(hex: "#EA4335")
    )
```

### Built-in brands
| Brand | Primary | Secondary | Neutral |
|-------|---------|-----------|---------|
| `.coralCamo` | Forest green | Coral red | Warm |
| `.seaLime` | Navy blue | Lime green | Cool |
| `.mistyRose` | Slate blue | Pink | Cool blue |
| `.blueHaze` | Royal blue | Beige | Warm grey |

### Custom color derivation

When `primaryColor` or `secondaryColor` is provided, all shades are auto-derived:

- `primary80` → `color.opacity(0.7)`
- `primary100` → exact color
- `primary120` → color darkened 15% in HSB
- `secondary10` → `color.opacity(0.08)`
- `secondary40` → `color.opacity(0.35)`
- `secondary100` → exact color
- `secondary120` → color darkened 10% in HSB

Every component using `surfacePrimary*`, `surfaceSecondary*`, `textPrimary100`, `textSecondary100`, `borderPrimary100`, `borderSecondary100` updates automatically — no component changes needed.

### Rules
- **NEVER** pass `primaryColor`/`secondaryColor` inside component files — only at the app root `.designSystem()` call
- **NEVER** override individual component colors to match a brand color — the theme propagates it everywhere
- The neutral scale always comes from the `Brand` enum — custom colors only affect primary/secondary shades
- Full theming reference: `docs/theming.md`

## Per-Component AI Reference YAMLs

Each DS component has a dedicated YAML in `docs/ai/components/` with:
- `use_when` / `never_use_when`
- Per-variant/size/style context (when to use each variant)
- Exact padding/spacing values from source code
- Figma CSS variable → Swift token mappings
- Hard implementation rules

**ALWAYS read the component YAML before implementing any component.**
- Index: `docs/ai/components/INDEX.yaml`
- Examples: `docs/ai/components/DSButton.yaml`, `docs/ai/components/DSCard.yaml`, etc.

## Figma File Reference

- **File key**: `4kcXyu53LWpUMVyhPvA4hY`
- **File name**: HaHo — Mobile UI Kit — Multibrand Design System
- Always use `get_design_context` or `get_screenshot` to verify designs before implementation

## Project Structure

- **DS Components**: `ios/Sources/DesignSystem/Components/` (public, in SPM package)
- **Theme/Tokens**: `ios/Sources/DesignSystem/Theme/` and `ios/Sources/DesignSystem/Tokens/`
- **App Pages**: `ios/VitrineApp/VitrineApp/Views/Pages/`
- **Assets**: `ios/VitrineApp/VitrineApp/Assets.xcassets/`
- **Xcode Project**: `ios/VitrineApp/VitrineApp.xcodeproj/project.pbxproj` — must register all new page files
- **Deployment target**: iOS 16.0 — do not use iOS 17+ APIs (e.g., use old `onChange(of:)` syntax)

## Build & Run

```bash
# Build
xcodebuild -project VitrineApp.xcodeproj -scheme VitrineApp -destination 'id=9F00C211-4F98-4D02-A49D-DF1F10809873' -quiet build

# Install + launch on simulator
xcrun simctl install 9F00C211-4F98-4D02-A49D-DF1F10809873 ~/Library/Developer/Xcode/DerivedData/VitrineApp-*/Build/Products/Debug-iphonesimulator/VitrineApp.app
xcrun simctl launch 9F00C211-4F98-4D02-A49D-DF1F10809873 com.haho.vitrine.VitrineApp
```

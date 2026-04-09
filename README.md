# HaHo Design System

A fully tokenized, enum-driven design system for native iOS (SwiftUI). Switch two enum values and the entire UI transforms: colors, typography, spacing, radius, elevation, and component styles. No component code changes required.

---

**58 components** &nbsp;|&nbsp; **4 brands** &nbsp;|&nbsp; **16 theme combinations** &nbsp;|&nbsp; **Zero dependencies**

---

## What It Is

HaHo is a production-grade Swift Package that provides a complete set of reusable UI components, a multi-brand token system, and a theme engine. It ships as a single SPM dependency with no third-party requirements.

Every visual property reads from a resolved theme configuration. There are no hardcoded colors, no magic numbers, no inline styles. Components adapt automatically when the theme changes.

The system was designed from the ground up for AI-assisted development: specify a Brand and Style, and every component renders correctly without manual tweaking.

## Architecture

HaHo uses a **2-axis enum-driven architecture**:

```
Brand (primitive palette)          Style (color mode + shape)
  .coralCamo                         .lightRounded
  .seaLime                           .darkRounded
  .mistyRose                         .lightSharp
  .blueHaze                          .darkSharp
```

Brand selects **what** the raw color values are. Style selects **how** those values map to semantic roles. Together they resolve into a `ThemeConfiguration` that components read from the SwiftUI environment.

```
Brand x Style = ThemeConfiguration

primitives --> semantic tokens --> component tokens --> views
```

**Key behaviors in dark mode:** primary and secondary colors swap roles, the neutral scale inverts. Sharp styles reset all corner radii to zero (except `full`). These rules are encoded in the token layer, not in component code.

## Components

58 production-ready SwiftUI components organized by category:

| Category | Components |
|----------|------------|
| **Core** | Text, Icon, IconImage, Divider, Badge, Tooltip |
| **Actions** | Button, Chip, Toggle, Checkbox, Radio |
| **Inputs** | TextField, TextArea, SearchField, Dropdown, CodeInput, DatePicker, DayPicker, WeekStrip |
| **Pickers** | SegmentedPicker, IconSegmentedPicker, CalendarGrid, TimelineGrid |
| **Navigation** | TopAppBar, BottomAppBar, BottomNavOverlay, TabView, NavigationMenu, IconSidebar, SideMenuLayout |
| **Feedback** | Alert, AlertDialog, Banner, ProgressCircle |
| **Cards** | Card, StackedCard, StackedCardCarousel, ProductCard, ProductTeaser, EventCard, MetricCard, UserCard, StatRow |
| **Media** | Avatar, PhotoGrid, VideoPlayer, Carousel, CarouselDeck |
| **Lists** | ListItem, FormField, FeedPost |
| **Charts** | BarChart, HorizontalBarChart, StackedBarChart, LineChart, LollipopChart, StatsChart, SemiCircularGauge, WeatherChart |

## Quick Start

### Installation (Swift Package Manager)

Add the package to your `Package.swift` or via Xcode > File > Add Package Dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/design-systems.git", from: "1.0.0")
]
```

### Apply a Theme

Set the brand and style at the root of your view tree:

```swift
import DesignSystem

struct AppRoot: View {
    var body: some View {
        ContentView()
            .designSystem(brand: .coralCamo, style: .lightRounded)
    }
}
```

### Use Components

Access the theme from any child view via the environment:

```swift
@Environment(\.theme) private var theme

var body: some View {
    DSCard(background: theme.colors.surfaceNeutral2) {
        DSText("Hello", style: theme.typography.body, color: theme.colors.textNeutral9)
    }
}
```

### Switch Themes at Runtime

Changing the two enum values transforms the entire interface:

```swift
// Warm earth tones, rounded corners, light mode
.designSystem(brand: .coralCamo, style: .lightRounded)

// Cool blues, sharp edges, dark mode
.designSystem(brand: .seaLime, style: .darkSharp)
```

## Token System

HaHo uses a three-tier token hierarchy sourced from Figma design variables:

```
Primitive Tokens        Semantic Tokens           Component Tokens
(per brand)             (per style)               (per component)

brand.primary100   -->  surfacePrimary100    -->  button.background
neutrals.9         -->  textNeutral9         -->  card.titleColor
radius.md          -->  radiusMd             -->  input.cornerRadius
spacing.lg         -->  (pass-through)       -->  card.padding
```

**Primitive tokens** define raw values: brand colors (7 steps per brand), a 15-step neutral scale with unique undertone per brand, semantic colors (error, warning, validated, info), spacing, radius, border widths, opacity levels, and drop shadows.

**Semantic tokens** map primitives to roles based on the active Style. Light modes and dark modes resolve to different primitives. Rounded and sharp modes resolve to different radii.

**Component tokens** are consumed directly by DS components. Adding a new brand requires only a new primitive palette. Adding a new style requires only a new semantic mapping. Components never change.

Token definitions live in the [`tokens/`](tokens/) directory as JSON. The runtime Swift code mirrors these values.

## Brands

| Brand | Primary | Secondary | Character |
|-------|---------|-----------|-----------|
| Coral Camo | Muted green-brown | Warm coral | Warm earth tones |
| Sea Lime | Deep blue | Vibrant lime | Cool and energetic |
| Misty Rose | Slate blue-grey | Soft pink | Muted and elegant |
| Blue Haze | Vivid blue | Warm beige | Bold and grounded |

## Repository Layout

```
Package.swift                   Root SPM package
Sources/DesignSystem/           Reusable Swift Package code
ios/
  Sources/DesignSystem/         Symlinked package source
  VitrineApp/                   Showcase app (Xcode project)
  DemoApp/                      Demo application
  Tests/                        Component and theme tests
tokens/
  primitives.json               82 variables x 4 brands
  tokens.json                   51 variables x 4 modes
docs/
  components/                   Per-component usage documentation
  ACCESSIBILITY.md              Accessibility expectations
  theming.md                    Theme system guide
  ai/                           AI-facing design contracts
```

## Screenshots

### Components

<p align="center">
  <img src="screenshots/buttons.png" width="230" alt="Buttons - Filled, Outlined, Text, Sizes" />
  <img src="screenshots/textfields.png" width="230" alt="Text Fields - Empty, Filled, Error, Validated, Search" />
  <img src="screenshots/selection.png" width="230" alt="Selection Controls - Checkbox, Radio, Toggle" />
</p>

*Run the VitrineApp scheme in Xcode to preview all 16 theme combinations across 4 brands and 4 styles.*

## AI-Driven Design

HaHo was built to work with AI coding agents. The `docs/ai/` directory contains a machine-readable contract layer that lets an LLM compose screens correctly without reading Swift source every time.

### Design System Contract

[`docs/ai/design-system-contract.yaml`](docs/ai/design-system-contract.yaml) is the central registry. It declares:

- Theme axes (brand x style), token layers, and source-of-truth file paths
- Custom color override API (swap primary/secondary at the app root)
- Every component with its variants, when-to-use rules, and Figma node mappings
- Page patterns for common screen families (auth, profile, alerts, onboarding)

### Component YAML Contracts

Each of the 59 components has a dedicated YAML file in [`docs/ai/components/`](docs/ai/components/). A contract includes:

- **Styles and variants** with exact token references (e.g., `filledA` uses `surfaceSecondary100`)
- **When to use / never use** guidance so AI picks the right component
- **Figma signals** mapping hex colors and layout cues to style enums
- **Figma rules** (typed rule objects) that enforce correctness during Figma generation

Example from `DSButton.yaml`:
```yaml
filledA:
  background: theme.colors.surfaceSecondary100
  foreground: theme.colors.textNeutral9
  use_when:
    - Primary CTA on dark/primary backgrounds
    - "Sign In", "Continue", "Pay Now" on auth screens
```

### Rule Schema

[`docs/ai/rule-schema.yaml`](docs/ai/rule-schema.yaml) defines a typed rule system for automated Figma builds and checks. Rules have:

- **Triggers**: `after_instantiate`, `before_instantiate`, `after_append`, `after_set_property`, `after_detach`
- **Conditions**: `always`, `parent_fill_is`, `parent_fill_dark`, `variant_in`, `item_count_lte`
- **Actions**: `set_property`, `set_fill`, `swap_component`, `match_fill_to_parent`
- **Checks**: assertions (`equals`, `fill_matches_rgb`, `component_id_in`) with severity levels and auto-fix flags

This lets both builder and checker agents enforce the same rules identically.

### Page Spec Pipeline

The system supports a full spec-to-Figma pipeline:

1. AI generates a page spec (YAML) from a prompt
2. Validator checks structural + semantic correctness against the contract
3. Transformer converts the spec into a Figma-oriented instance tree
4. Output goes to a Figma plugin or Figma Playground handoff

Seven example specs ship in [`docs/ai/examples/`](docs/ai/examples/): auth login, auth verification, alert dialog, alert banner, profile hero, profile stats, and onboarding walkthrough.

### Claude Code Skills

The design system ships with dedicated [Claude Code skills](https://github.com/omardoucoure/claude-skills) for common workflows:

| Skill | What it does |
|-------|--------------|
| `check-ds-page` | Validates a Figma page against design system rules |
| `create-ds-component` | Creates reusable DS components from Figma designs |
| `create-ds-page` | Designs full mobile screens in Figma using DS components |
| `implement-ds-page` | Implements screens from Figma using existing DS components |
| `pixel-perfect-check` | Audits SwiftUI code against Figma for pixel-perfect accuracy |
| `figma-to-code` | Converts Figma designs to production code with mandatory property extraction |

### Zero-Hallucination Policy

The project's `CLAUDE.md` enforces a strict zero-hallucination policy for AI agents: every color, spacing, typography, and state value must be read directly from Figma design context. No guessing, no defaults, no assumptions. A mandatory extraction checklist covers fonts, colors, spacing, padding, radius, dimensions, opacity, and negative margins before any code is written.

## Requirements

- iOS 16+
- Swift 5.9+
- Xcode 15+

## Built By

[Omar Doucoure](https://omardoucoure.com)

## License

See [LICENSE](LICENSE) for details.

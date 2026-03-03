// HaHo Design System — iOS SPM Library
//
// A 2-axis, enum-driven design system.
// Brand (4 cases) × Style (4 cases) = 16 visual identities.
//
// Usage:
//   import DesignSystem
//
//   ContentView()
//       .designSystem(brand: .coralCamo, style: .lightRounded)
//
//   // In any child view:
//   @Environment(\.theme) private var theme
//   theme.colors.surfacePrimary100
//   theme.spacing.md
//   theme.typography.body.font

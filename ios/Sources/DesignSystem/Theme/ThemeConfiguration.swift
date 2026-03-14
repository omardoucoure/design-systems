import SwiftUI

/// The fully resolved theme: Brand + Style → all token values.
/// Immutable value type — a new instance is created on each Brand/Style change.
public struct ThemeConfiguration: Sendable {
    public let brand: Brand
    public let style: Style
    public let colors: ColorTokens
    public let radius: RadiusTokens
    public let spacing: SpacingTokens
    public let borders: BorderTokens
    public let opacity: OpacityTokens
    public let elevation: ElevationTokens
    public let typography: TypographyTokens
    public let isDark: Bool
    public let isSharp: Bool

    public init(brand: Brand, style: Style, primaryColor: Color? = nil, secondaryColor: Color? = nil) {
        let primitives = brand.primitives.withOverrides(primary: primaryColor, secondary: secondaryColor)

        self.brand = brand
        self.style = style
        self.colors = style.resolveColors(from: primitives)
        self.radius = style.resolveRadius()
        self.spacing = style.resolveSpacing()
        self.borders = style.resolveBorders()
        self.opacity = .shared
        self.elevation = .shared
        self.typography = .shared
        self.isDark = style.isDark
        self.isSharp = style.isSharp
    }
}

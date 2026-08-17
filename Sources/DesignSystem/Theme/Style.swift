import SwiftUI

/// The Style axis: controls color mode (light/dark) and shape (rounded/sharp).
/// Maps Brand primitives to semantic tokens.
public enum Style: String, CaseIterable, Sendable, Identifiable {
    case lightRounded
    case darkRounded
    case lightSharp
    case darkSharp

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .lightRounded: return "Light Rounded"
        case .darkRounded: return "Dark Rounded"
        case .lightSharp: return "Light Sharp"
        case .darkSharp: return "Dark Sharp"
        }
    }

    public var isDark: Bool {
        switch self {
        case .lightRounded, .lightSharp: return false
        case .darkRounded, .darkSharp: return true
        }
    }

    public var isSharp: Bool {
        switch self {
        case .lightRounded, .darkRounded: return false
        case .lightSharp, .darkSharp: return true
        }
    }

    public init(isDark: Bool, isSharp: Bool) {
        switch (isDark, isSharp) {
        case (false, false): self = .lightRounded
        case (true, false): self = .darkRounded
        case (false, true): self = .lightSharp
        case (true, true): self = .darkSharp
        }
    }

    // MARK: - System Appearance

    /// Resolves the style for a system color scheme, keeping the given shape.
    public init(colorScheme: ColorScheme, shape: StyleShape) {
        self.init(isDark: colorScheme == .dark, isSharp: shape == .sharp)
    }

    public static func rounded(for colorScheme: ColorScheme) -> Style {
        Style(colorScheme: colorScheme, shape: .rounded)
    }

    public static func sharp(for colorScheme: ColorScheme) -> Style {
        Style(colorScheme: colorScheme, shape: .sharp)
    }

    /// Returns this style re-resolved for a color scheme, preserving its shape.
    public func resolved(for colorScheme: ColorScheme) -> Style {
        Style(isDark: colorScheme == .dark, isSharp: isSharp)
    }

    public var shape: StyleShape {
        isSharp ? .sharp : .rounded
    }

    // MARK: - Color Resolution

    /// Resolves semantic color tokens from brand primitives.
    /// Dark mode: inverts neutrals and swaps primary/secondary.
    public func resolveColors(from p: BrandPrimitives) -> ColorTokens {
        let semantic = SemanticColors.shared

        if isDark {
            return ColorTokens(
                // Surface — dark: inverted neutrals, swapped brand colors
                surfaceNeutral05: p.neutrals.n9,
                surfaceNeutral1: p.neutrals.n85,
                surfaceNeutral2: p.neutrals.n8,
                surfaceNeutral3: p.neutrals.n7,
                surfaceNeutral9: p.neutrals.n05,
                surfacePrimary80: p.primary80,
                surfacePrimary100: p.secondary100,
                surfacePrimary120: p.neutrals.n5,
                surfaceSecondary100: p.primary100,
                surfaceSecondary120: p.primary120,
                surfaceSecondary40: p.primary80,
                surfaceSecondary10: p.neutrals.n85,
                surfaceHero: p.neutrals.n95,
                surfaceHeroDeep: p.neutrals.n95,
                // Text — dark: inverted
                textNeutral9: p.neutrals.n3,
                textNeutral8: p.neutrals.n2,
                textNeutral6: p.neutrals.n3,
                textNeutral3: p.neutrals.n8,
                textNeutral2: p.neutrals.n85,
                textNeutral05: p.neutrals.n9,
                textOnHero: p.neutrals.n05,
                textPrimary100: p.secondary100,
                textSecondary100: p.primary100,
                textOpacity75: 0.75,
                textOpacity50: 0.50,
                // Border — dark: inverted neutrals, brand colors stay
                borderNeutral95: p.neutrals.n3,
                borderNeutral8: p.neutrals.n2,
                borderNeutral3: p.neutrals.n8,
                borderNeutral2: p.neutrals.n85,
                borderNeutral05: p.neutrals.n9,
                borderSecondary100: p.secondary100,
                borderPrimary100: p.primary100,
                // Semantic — shared
                error: semantic.error,
                warning: semantic.warning,
                success: semantic.success,
                validated: semantic.validated,
                infoFocus: semantic.infoFocus,
                errorBg: semantic.errorBg,
                warningBg: semantic.warningBg,
                successBg: semantic.successBg,
                infoBg: semantic.infoBg,
                // Accent on surface — dark: the card is the primary fill, so the
                // accent must come from the secondary ramp to stay visible.
                accentOnSurface: p.secondary100,
                onAccentText: p.primary120,
                // Data series — dark
                dataSeries: p.secondary100,
                dataSeriesMuted: p.secondary40,
                dataSeriesAlt: p.neutrals.n4,
                dataTrack: p.primary80
            )
        } else {
            return ColorTokens(
                // Surface — light: direct mapping
                surfaceNeutral05: p.neutrals.n05,
                surfaceNeutral1: p.neutrals.n1,
                surfaceNeutral2: p.neutrals.n2,
                surfaceNeutral3: p.neutrals.n3,
                surfaceNeutral9: p.neutrals.n9,
                surfacePrimary80: p.primary80,
                surfacePrimary100: p.primary100,
                surfacePrimary120: p.primary120,
                surfaceSecondary100: p.secondary100,
                surfaceSecondary120: p.secondary120,
                surfaceSecondary40: p.secondary40,
                surfaceSecondary10: p.secondary10,
                surfaceHero: p.primary100,
                surfaceHeroDeep: p.primary120,
                // Text — light: direct
                textNeutral9: p.neutrals.n9,
                textNeutral8: p.neutrals.n8,
                textNeutral6: p.neutrals.n6,
                textNeutral3: p.neutrals.n3,
                textNeutral2: p.neutrals.n2,
                textNeutral05: p.neutrals.n05,
                textOnHero: p.neutrals.n05,
                textPrimary100: p.primary100,
                textSecondary100: p.secondary100,
                textOpacity75: 0.75,
                textOpacity50: 0.50,
                // Border — light: direct
                borderNeutral95: p.neutrals.n9,
                borderNeutral8: p.neutrals.n8,
                borderNeutral3: p.neutrals.n3,
                borderNeutral2: p.neutrals.n2,
                borderNeutral05: p.neutrals.n05,
                borderSecondary100: p.secondary100,
                borderPrimary100: p.primary100,
                // Semantic — shared
                error: semantic.error,
                warning: semantic.warning,
                success: semantic.success,
                validated: semantic.validated,
                infoFocus: semantic.infoFocus,
                errorBg: semantic.errorBg,
                warningBg: semantic.warningBg,
                successBg: semantic.successBg,
                infoBg: semantic.infoBg,
                // Accent on surface — light
                accentOnSurface: p.primary100,
                onAccentText: p.neutrals.n05,
                // Data series — light
                dataSeries: p.primary100,
                dataSeriesMuted: p.primary80,
                dataSeriesAlt: p.neutrals.n6,
                dataTrack: p.neutrals.n3
            )
        }
    }

    // MARK: - Radius Resolution

    /// Resolves radius tokens. Sharp styles zero all values except `full`.
    public func resolveRadius() -> RadiusTokens {
        isSharp ? .sharp : .rounded
    }

    // MARK: - Spacing Resolution

    /// Spacing is pass-through (identical across all modes).
    public func resolveSpacing() -> SpacingTokens {
        .shared
    }

    // MARK: - Border Resolution

    /// Border widths and opacities are shared across all modes.
    public func resolveBorders() -> BorderTokens {
        .shared
    }
}

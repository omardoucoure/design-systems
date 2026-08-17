import SwiftUI

/// Resolved semantic color tokens (surface + text + border + semantic).
/// Values depend on Brand (palette) and Style (light/dark inversion + primary/secondary swap).
public struct ColorTokens: Sendable {
    // MARK: Surface (8)
    public let surfaceNeutral05: Color
    public let surfaceNeutral1: Color
    public let surfaceNeutral2: Color
    public let surfaceNeutral3: Color
    public let surfaceNeutral9: Color
    public let surfacePrimary80: Color
    public let surfacePrimary100: Color
    public let surfacePrimary120: Color
    public let surfaceSecondary100: Color
    public let surfaceSecondary120: Color
    public let surfaceSecondary40: Color
    public let surfaceSecondary10: Color
    public let surfaceHero: Color
    public let surfaceHeroDeep: Color

    // MARK: Text (9)
    public let textNeutral9: Color
    public let textNeutral8: Color
    public let textNeutral6: Color
    public let textNeutral3: Color
    public let textNeutral2: Color
    public let textNeutral05: Color
    public let textOnHero: Color
    public let textPrimary100: Color
    public let textSecondary100: Color
    public let textOpacity75: Double
    public let textOpacity50: Double

    // MARK: Border (7 colors)
    public let borderNeutral95: Color
    public let borderNeutral8: Color
    public let borderNeutral3: Color
    public let borderNeutral2: Color
    public let borderNeutral05: Color
    public let borderSecondary100: Color
    public let borderPrimary100: Color

    // MARK: Semantic (5)
    public let error: Color
    public let warning: Color
    public let success: Color
    public let validated: Color
    public let infoFocus: Color

    // MARK: Semantic tint backgrounds (4)
    public let errorBg: Color
    public let warningBg: Color
    public let successBg: Color
    public let infoBg: Color

    // MARK: Accent on surface (2)
    /// The brand accent as drawn *on a card*. In dark mode the card itself is the
    /// primary fill, so an accent drawn in primary would vanish into it.
    public let accentOnSurface: Color
    /// Foreground for content sitting on an `accentOnSurface` fill.
    public let onAccentText: Color

    // MARK: Data series (4)
    public let dataSeries: Color
    public let dataSeriesMuted: Color
    public let dataSeriesAlt: Color
    public let dataTrack: Color
}

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
    public let surfacePrimary100: Color
    public let surfacePrimary120: Color
    public let surfaceSecondary100: Color

    // MARK: Text (9)
    public let textNeutral9: Color
    public let textNeutral8: Color
    public let textNeutral3: Color
    public let textNeutral2: Color
    public let textNeutral05: Color
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

    // MARK: Semantic (4)
    public let error: Color
    public let warning: Color
    public let validated: Color
    public let infoFocus: Color
}

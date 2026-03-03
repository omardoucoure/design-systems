import Foundation

/// Resolved radius tokens. Sharp styles set all values to 0 except `full`.
public struct RadiusTokens: Sendable {
    public let none: CGFloat
    public let xxs: CGFloat
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let xxl: CGFloat
    public let xxxl: CGFloat
    public let full: CGFloat

    /// Rounded mode: pass-through from primitive radius scale.
    public static let rounded = RadiusTokens(
        none: 0, xxs: 4, xs: 8, sm: 12, md: 16,
        lg: 24, xl: 32, xxl: 40, xxxl: 64, full: 360
    )

    /// Sharp mode: all values zeroed except full.
    public static let sharp = RadiusTokens(
        none: 0, xxs: 0, xs: 0, sm: 0, md: 0,
        lg: 0, xl: 0, xxl: 0, xxxl: 0, full: 360
    )
}

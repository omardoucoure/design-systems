import Foundation

/// Border width and opacity tokens (shared across all modes).
public struct BorderTokens: Sendable {
    // Widths
    public let widthNone: CGFloat = 0
    public let widthSm: CGFloat = 1
    public let widthMd: CGFloat = 2
    public let widthLg: CGFloat = 4

    // Opacities
    public let opacity75: Double = 0.75
    public let opacity50: Double = 0.50

    public static let shared = BorderTokens()

    public init() {}
}

import Foundation

/// Spacing tokens (pass-through, identical across all modes).
public struct SpacingTokens: Sendable {
    public let none: CGFloat = 0
    public let xxxs: CGFloat = 2
    public let xxs: CGFloat = 4
    public let xs: CGFloat = 8
    public let sm: CGFloat = 12
    public let md: CGFloat = 16
    public let lg: CGFloat = 24
    public let xl: CGFloat = 32
    public let xxl: CGFloat = 40
    public let xxxl: CGFloat = 48
    public let xxxxl: CGFloat = 64

    public static let shared = SpacingTokens()

    public init() {}
}

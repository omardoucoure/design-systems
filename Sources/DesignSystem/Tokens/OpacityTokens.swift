import Foundation

/// Opacity tokens (shared across all modes).
public struct OpacityTokens: Sendable {
    public let none: Double = 0
    public let sm: Double = 0.25
    public let md: Double = 0.50
    public let lg: Double = 0.75
    public let full: Double = 1.0

    public static let shared = OpacityTokens()

    public init() {}
}

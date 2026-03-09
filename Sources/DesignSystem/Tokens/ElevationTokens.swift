import SwiftUI

/// A single shadow layer for composing elevation presets.
public struct ShadowLayer: Sendable {
    public let color: Color
    public let opacity: Double
    public let x: CGFloat
    public let y: CGFloat
    public let blur: CGFloat
    public let spread: CGFloat

    public init(color: Color, opacity: Double, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) {
        self.color = color
        self.opacity = opacity
        self.x = x
        self.y = y
        self.blur = blur
        self.spread = spread
    }
}

/// Elevation presets composed of shadow layers (shared across all modes).
public struct ElevationTokens: Sendable {
    public let none: [ShadowLayer]
    public let sm: [ShadowLayer]

    public static let shared = ElevationTokens(
        none: [],
        sm: [
            ShadowLayer(color: .black, opacity: 0.10, x: 0, y: 4, blur: 8, spread: -2),
            ShadowLayer(color: .black, opacity: 0.06, x: 0, y: 2, blur: 2, spread: -2)
        ]
    )
}

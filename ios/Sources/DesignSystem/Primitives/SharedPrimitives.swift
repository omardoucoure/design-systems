import SwiftUI

// MARK: - Spacing Scale

/// 11-step spacing scale (shared across all brands and styles).
public struct SpacingScale: Sendable {
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

    public init() {}
}

// MARK: - Radius Scale

/// 10-step radius scale (shared across all brands).
public struct RadiusScale: Sendable {
    public let none: CGFloat = 0
    public let xxs: CGFloat = 4
    public let xs: CGFloat = 8
    public let sm: CGFloat = 12
    public let md: CGFloat = 16
    public let lg: CGFloat = 24
    public let xl: CGFloat = 32
    public let xxl: CGFloat = 40
    public let xxxl: CGFloat = 64
    public let full: CGFloat = 360

    public init() {}
}

// MARK: - Border Width Scale

/// 4-step border width scale (shared).
public struct BorderWidthScale: Sendable {
    public let none: CGFloat = 0
    public let sm: CGFloat = 1
    public let md: CGFloat = 2
    public let lg: CGFloat = 4

    public init() {}
}

// MARK: - Opacity Scale

/// 5-step opacity scale (shared).
public struct OpacityScale: Sendable {
    public let none: Double = 0
    public let sm: Double = 0.25
    public let md: Double = 0.50
    public let lg: Double = 0.75
    public let full: Double = 1.0

    public init() {}
}

// MARK: - Drop Shadow Scale

/// Drop shadow positioning, blur, and spread primitives.
public struct DropShadowPositioning: Sendable {
    public let none: CGFloat = 0
    public let xxxs: CGFloat = 2
    public let xxs: CGFloat = 4
    public let xs: CGFloat = 8
    public let sm: CGFloat = 12
    public let md: CGFloat = 16
    public let lg: CGFloat = 20
    public let xl: CGFloat = 24
    public let xxl: CGFloat = 32
    public let xxxl: CGFloat = 48

    public init() {}
}

public struct DropShadowBlur: Sendable {
    public let none: CGFloat = 0
    public let xxs: CGFloat = 2
    public let xs: CGFloat = 4
    public let sm: CGFloat = 8
    public let md: CGFloat = 16
    public let lg: CGFloat = 24
    public let xl: CGFloat = 48
    public let xxl: CGFloat = 64

    public init() {}
}

public struct DropShadowSpread: Sendable {
    public let none: CGFloat = 0
    public let xxs: CGFloat = -2
    public let xs: CGFloat = -4
    public let sm: CGFloat = -8
    public let md: CGFloat = -12
    public let lg: CGFloat = -16
    public let xl: CGFloat = -20
    public let xxl: CGFloat = -24

    public init() {}
}

public struct DropShadowScale: Sendable {
    public let positioning: DropShadowPositioning
    public let blur: DropShadowBlur
    public let spread: DropShadowSpread

    public init() {
        self.positioning = DropShadowPositioning()
        self.blur = DropShadowBlur()
        self.spread = DropShadowSpread()
    }
}

// MARK: - Shared Primitives Container

/// All shared primitives (same for every brand/style).
public struct SharedPrimitives: Sendable {
    public let spacing: SpacingScale
    public let radius: RadiusScale
    public let borderWidth: BorderWidthScale
    public let opacity: OpacityScale
    public let dropShadow: DropShadowScale
    public let semanticColors: SemanticColors

    public static let shared = SharedPrimitives()

    public init() {
        self.spacing = SpacingScale()
        self.radius = RadiusScale()
        self.borderWidth = BorderWidthScale()
        self.opacity = OpacityScale()
        self.dropShadow = DropShadowScale()
        self.semanticColors = SemanticColors.shared
    }
}

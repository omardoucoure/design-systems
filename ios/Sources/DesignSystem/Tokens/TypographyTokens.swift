import SwiftUI

/// A single typography style definition.
public struct TypographyStyle: Sendable {
    public let size: CGFloat
    public let weight: Font.Weight
    public let lineHeight: CGFloat
    public let letterSpacing: CGFloat

    public var font: Font {
        .custom("DMSans-\(weightSuffix)", size: size)
    }

    private var weightSuffix: String {
        switch weight {
        case .semibold: return "SemiBold"
        case .medium: return "Medium"
        default: return "Regular"
        }
    }

    /// Line spacing = (lineHeight * size) - size
    public var lineSpacing: CGFloat {
        (lineHeight * size) - size
    }

    /// Tracking in points (letterSpacing is a percentage, e.g. -5.0 means -5%)
    public var tracking: CGFloat {
        size * (letterSpacing / 100.0)
    }
}

/// Named typography styles using DM Sans (shared across all modes).
public struct TypographyTokens: Sendable {
    public let display1: TypographyStyle
    public let display2: TypographyStyle
    public let h1: TypographyStyle
    public let h2: TypographyStyle
    public let h3: TypographyStyle
    public let h4: TypographyStyle
    public let h5: TypographyStyle
    public let h6: TypographyStyle
    public let largeSemiBold: TypographyStyle
    public let largeRegular: TypographyStyle
    public let bodySemiBold: TypographyStyle
    public let body: TypographyStyle
    public let bodyRegular: TypographyStyle
    public let label: TypographyStyle
    public let caption: TypographyStyle
    public let captionRegular: TypographyStyle
    public let small: TypographyStyle
    public let smallSemiBold: TypographyStyle
    public let smallRegular: TypographyStyle
    public let tiny: TypographyStyle
    public let tinySemiBold: TypographyStyle
    public let tinyRegular: TypographyStyle

    public static let shared = TypographyTokens(
        display1: TypographyStyle(size: 56, weight: .medium, lineHeight: 1.2, letterSpacing: -5.0),
        display2: TypographyStyle(size: 48, weight: .medium, lineHeight: 1.2, letterSpacing: -5.0),
        h1: TypographyStyle(size: 40, weight: .medium, lineHeight: 1.2, letterSpacing: -4.5),
        h2: TypographyStyle(size: 36, weight: .medium, lineHeight: 1.2, letterSpacing: -4.5),
        h3: TypographyStyle(size: 32, weight: .medium, lineHeight: 1.2, letterSpacing: -4.5),
        h4: TypographyStyle(size: 24, weight: .medium, lineHeight: 1.4, letterSpacing: -4.0),
        h5: TypographyStyle(size: 20, weight: .medium, lineHeight: 1.4, letterSpacing: -4.0),
        h6: TypographyStyle(size: 18, weight: .medium, lineHeight: 1.4, letterSpacing: -3.5),
        largeSemiBold: TypographyStyle(size: 18, weight: .semibold, lineHeight: 1.5, letterSpacing: -3.5),
        largeRegular: TypographyStyle(size: 18, weight: .regular, lineHeight: 1.5, letterSpacing: -3.5),
        bodySemiBold: TypographyStyle(size: 16, weight: .semibold, lineHeight: 1.5, letterSpacing: -2.5),
        body: TypographyStyle(size: 16, weight: .medium, lineHeight: 1.5, letterSpacing: -2.5),
        bodyRegular: TypographyStyle(size: 16, weight: .regular, lineHeight: 1.5, letterSpacing: -2.5),
        label: TypographyStyle(size: 14, weight: .semibold, lineHeight: 1.5, letterSpacing: -2.5),
        caption: TypographyStyle(size: 14, weight: .medium, lineHeight: 1.5, letterSpacing: -2.5),
        captionRegular: TypographyStyle(size: 14, weight: .regular, lineHeight: 1.5, letterSpacing: -2.5),
        small: TypographyStyle(size: 12, weight: .medium, lineHeight: 1.5, letterSpacing: -2.0),
        smallSemiBold: TypographyStyle(size: 12, weight: .semibold, lineHeight: 1.5, letterSpacing: -2.0),
        smallRegular: TypographyStyle(size: 12, weight: .regular, lineHeight: 1.5, letterSpacing: -2.0),
        tiny: TypographyStyle(size: 10, weight: .medium, lineHeight: 1.5, letterSpacing: -1.5),
        tinySemiBold: TypographyStyle(size: 10, weight: .semibold, lineHeight: 1.5, letterSpacing: -1.5),
        tinyRegular: TypographyStyle(size: 10, weight: .regular, lineHeight: 1.5, letterSpacing: -1.5)
    )
}

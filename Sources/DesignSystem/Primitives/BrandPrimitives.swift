import SwiftUI

/// 7 brand colors + 15-step neutral scale, resolved from a Brand enum case.
public struct BrandPrimitives: Sendable {
    public let primary80: Color
    public let primary100: Color
    public let primary120: Color
    public let secondary10: Color
    public let secondary40: Color
    public let secondary100: Color
    public let secondary120: Color
    public let neutrals: NeutralScale

    public init(
        primary80: Color, primary100: Color, primary120: Color,
        secondary10: Color, secondary40: Color, secondary100: Color, secondary120: Color,
        neutrals: NeutralScale
    ) {
        self.primary80 = primary80
        self.primary100 = primary100
        self.primary120 = primary120
        self.secondary10 = secondary10
        self.secondary40 = secondary40
        self.secondary100 = secondary100
        self.secondary120 = secondary120
        self.neutrals = neutrals
    }

    /// Returns a copy of these primitives with custom primary and/or secondary colors applied.
    ///
    /// - Parameters:
    ///   - primary: Replaces all primary shades. `80` is lightened, `120` is darkened automatically.
    ///   - secondary: Replaces all secondary shades. `10`/`40` tints and `120` are derived automatically.
    public func withOverrides(primary: Color? = nil, secondary: Color? = nil) -> BrandPrimitives {
        BrandPrimitives(
            primary80:     primary.map { $0.opacity(0.7) } ?? primary80,
            primary100:    primary ?? primary100,
            primary120:    primary.map { $0.brightness(-0.15) } ?? primary120,
            secondary10:   secondary.map { $0.opacity(0.08) } ?? secondary10,
            secondary40:   secondary.map { $0.opacity(0.35) } ?? secondary40,
            secondary100:  secondary ?? secondary100,
            secondary120:  secondary.map { $0.brightness(-0.1) } ?? secondary120,
            neutrals: neutrals
        )
    }
}

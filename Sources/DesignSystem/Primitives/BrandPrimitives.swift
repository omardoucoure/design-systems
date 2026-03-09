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
}

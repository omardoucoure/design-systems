import SwiftUI

/// Shared semantic status colors (same across all brands).
public struct SemanticColors: Sendable {
    public let error: Color
    public let warning: Color
    public let validated: Color
    public let infoFocus: Color
    public let errorBg: Color
    public let warningBg: Color
    public let validatedBg: Color
    public let infoBg: Color

    public static let shared = SemanticColors(
        error: Color(hex: "#F93939"),
        warning: Color(hex: "#F2A83B"),
        validated: Color(hex: "#249F58"),
        infoFocus: Color(hex: "#53D5FF"),
        errorBg: Color(hex: "#FFE2E2"),
        warningBg: Color(hex: "#FFEFCE"),
        validatedBg: Color(hex: "#DCF5E5"),
        infoBg: Color(hex: "#DEF5FF")
    )
}

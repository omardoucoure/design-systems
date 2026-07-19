import SwiftUI

/// Shared semantic status colors (same across all brands).
public struct SemanticColors: Sendable {
    public let error: Color
    public let warning: Color
    public let success: Color
    public let validated: Color
    public let infoFocus: Color
    public let errorBg: Color
    public let warningBg: Color
    public let successBg: Color
    public let infoBg: Color

    public static let shared = SemanticColors(
        error: Color(hex: "#F93939"),
        warning: Color(hex: "#F2A83B"),
        success: Color(hex: "#249F58"),
        validated: Color(hex: "#76F057"),
        infoFocus: Color(hex: "#53D5FF"),
        errorBg: Color(hex: "#FFE2E2"),
        warningBg: Color(hex: "#FFEFCE"),
        successBg: Color(hex: "#DCF5E5"),
        infoBg: Color(hex: "#DEF5FF")
    )
}

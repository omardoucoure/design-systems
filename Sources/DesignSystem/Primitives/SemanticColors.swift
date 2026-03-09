import SwiftUI

/// Shared semantic status colors (same across all brands).
public struct SemanticColors: Sendable {
    public let error: Color
    public let warning: Color
    public let validated: Color
    public let infoFocus: Color

    public static let shared = SemanticColors(
        error: Color(hex: "#FF6565"),
        warning: Color(hex: "#FFD143"),
        validated: Color(hex: "#76F057"),
        infoFocus: Color(hex: "#53D5FF")
    )
}

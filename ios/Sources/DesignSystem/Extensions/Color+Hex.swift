import SwiftUI

extension Color {
    /// Creates a Color from a hex string (e.g. "#FF6A5F" or "FF6A5F").
    public init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let hex = cleaned.hasPrefix("#") ? String(cleaned.dropFirst()) : cleaned

        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

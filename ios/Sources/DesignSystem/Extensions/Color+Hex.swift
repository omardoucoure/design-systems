import SwiftUI
import UIKit

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

    /// Returns the color with its brightness shifted by `amount` (positive = lighter, negative = darker).
    /// Operates in HSB space so hue and saturation are preserved.
    public func brightness(_ amount: Double) -> Color {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(hue: Double(h),
                     saturation: Double(s),
                     brightness: max(0, min(1, Double(b) + amount)),
                     opacity: Double(a))
    }
}

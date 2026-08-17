import SwiftUI

/// The shape axis of a `Style`, independent of its color mode.
/// Lets a host app pin corner treatment while the color mode follows the system appearance.
public enum StyleShape: String, CaseIterable, Sendable, Identifiable {
    case rounded
    case sharp

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .rounded: return "Rounded"
        case .sharp: return "Sharp"
        }
    }

    public func style(for colorScheme: ColorScheme) -> Style {
        Style(colorScheme: colorScheme, shape: self)
    }
}

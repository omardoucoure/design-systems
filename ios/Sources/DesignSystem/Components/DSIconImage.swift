import SwiftUI

// MARK: - DSIconImage

/// A themed icon image from the DSIcon catalog.
///
/// Replaces the common 5-line pattern:
/// ```swift
/// Image(dsIcon: .heart)
///     .resizable()
///     .renderingMode(.template)
///     .scaledToFit()
///     .frame(width: 24, height: 24)
///     .foregroundStyle(theme.colors.textNeutral9)
/// ```
/// With:
/// ```swift
/// DSIconImage(.heart, size: 24, color: theme.colors.textNeutral9)
/// ```
public struct DSIconImage: View {
    private let icon: DSIcon
    private let size: CGFloat
    private let color: Color

    public init(_ icon: DSIcon, size: CGFloat = 24, color: Color) {
        self.icon = icon
        self.size = size
        self.color = color
    }

    public var body: some View {
        Image(dsIcon: icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(color)
    }
}

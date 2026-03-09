import SwiftUI

// MARK: - DSText

/// A themed text view that applies typography token and color in one line.
///
/// Replaces the common 3-line pattern:
/// ```swift
/// Text("Hello")
///     .font(theme.typography.caption.font)
///     .tracking(theme.typography.caption.tracking)
///     .foregroundStyle(theme.colors.textNeutral9)
/// ```
/// With:
/// ```swift
/// DSText("Hello", style: theme.typography.caption, color: theme.colors.textNeutral9)
/// ```
public struct DSText: View {
    private let content: LocalizedStringKey
    private let style: TypographyStyle
    private let color: Color

    public init(_ content: LocalizedStringKey, style: TypographyStyle, color: Color) {
        self.content = content
        self.style = style
        self.color = color
    }

    public init(_ content: String, style: TypographyStyle, color: Color) {
        self.content = LocalizedStringKey(content)
        self.style = style
        self.color = color
    }

    public var body: some View {
        Text(content)
            .font(style.font)
            .tracking(style.tracking)
            .lineSpacing(style.lineSpacing)
            .foregroundStyle(color)
    }
}

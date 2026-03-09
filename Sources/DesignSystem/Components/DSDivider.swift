import SwiftUI

// MARK: - DSDividerStyle

public enum DSDividerStyle {
    /// Full-width divider edge to edge.
    case fullBleed
    /// Left-inset divider (16pt leading padding).
    case inset
    /// Middle-inset divider (16pt padding both sides).
    case middle
    /// Divider with a subheader text label below.
    case subheader(LocalizedStringKey)
}

// MARK: - DSDivider

/// A themed divider with four style variants.
///
/// Usage:
/// ```swift
/// DSDivider(style: .fullBleed)
/// DSDivider(style: .inset)
/// DSDivider(style: .middle)
/// DSDivider(style: .subheader("Section Title"))
/// ```
public struct DSDivider: View {
    @Environment(\.theme) private var theme

    private let style: DSDividerStyle
    private let color: Color?

    public init(style: DSDividerStyle = .fullBleed, color: Color? = nil) {
        self.style = style
        self.color = color
    }

    public var body: some View {
        switch style {
        case .fullBleed:
            dividerLine

        case .inset:
            dividerLine
                .padding(.leading, theme.spacing.md)

        case .middle:
            dividerLine
                .padding(.horizontal, theme.spacing.md)

        case .subheader(let text):
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                dividerLine
                Text(text)
                    .font(theme.typography.caption.font)
                    .tracking(theme.typography.caption.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
                    .padding(.horizontal, theme.spacing.md)
                    .padding(.bottom, theme.spacing.sm)
            }
        }
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(color ?? theme.colors.borderNeutral9_5)
            .frame(height: 1)
    }
}

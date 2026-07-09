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
    /// Full-width divider with a heavier line weight.
    case strong
    /// Full-width dashed divider.
    case dotted
    /// Centered label between two horizontal rules.
    case label(LocalizedStringKey)
}

// MARK: - DSDivider

/// A themed divider with four style variants.
///
/// **Modifier-based API (preferred):**
/// ```swift
/// DSDivider()
///
/// DSDivider()
///     .dividerStyle(.inset)
///
/// DSDivider()
///     .dividerStyle(.subheader("Section Title"))
///     .dividerColor(theme.colors.borderNeutral2)
/// ```
///
/// **Legacy init (deprecated):**
/// ```swift
/// DSDivider(style: .fullBleed)
/// DSDivider(style: .inset, color: theme.colors.borderNeutral2)
/// ```
public struct DSDivider: View {
    @Environment(\.theme) private var theme

    private var _style: DSDividerStyle = .fullBleed
    private var _color: Color?

    // MARK: - Modifier-based init (preferred)

    public init() {}

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSDivider() with .dividerStyle(), .dividerColor() modifiers instead")
    public init(style: DSDividerStyle, color: Color? = nil) {
        self._style = style
        self._color = color
    }

    // MARK: - Modifiers

    public func dividerStyle(_ style: DSDividerStyle) -> DSDivider {
        var copy = self
        copy._style = style
        return copy
    }

    public func dividerColor(_ color: Color?) -> DSDivider {
        var copy = self
        copy._color = color
        return copy
    }

    // MARK: - Body

    public var body: some View {
        switch _style {
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

        case .strong:
            Rectangle()
                .fill(_color ?? theme.colors.borderNeutral3)
                .frame(height: 1)

        case .dotted:
            dottedLine

        case .label(let text):
            HStack(spacing: theme.spacing.sm) {
                dividerLine
                Text(text)
                    .font(theme.typography.small.font)
                    .tracking(theme.typography.small.tracking)
                    .foregroundStyle(theme.colors.textNeutral8)
                    .fixedSize()
                dividerLine
            }
        }
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(_color ?? theme.colors.borderNeutral95)
            .frame(height: 1)
    }

    private var dottedLine: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            .foregroundStyle(_color ?? theme.colors.borderNeutral3)
            .frame(height: 1)
    }
}

private struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

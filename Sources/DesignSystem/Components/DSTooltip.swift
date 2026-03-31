import SwiftUI

// MARK: - DSTooltipDirection

public enum DSTooltipDirection: Sendable, CaseIterable {
    case top, bottom, left, right
}

// MARK: - DSTooltipStyle

public enum DSTooltipStyle {
    /// Simple text tooltip.
    case simple(LocalizedStringKey)
    /// Rich tooltip with title, body, optional image, and optional action.
    case rich(
        title: LocalizedStringKey,
        body: LocalizedStringKey,
        image: AnyView? = nil,
        actionLabel: LocalizedStringKey? = nil,
        onAction: (() -> Void)? = nil
    )
}

// MARK: - DSTooltip

/// A themed tooltip that appears from a given direction with an arrow.
///
/// Usage (modifier-based):
/// ```swift
/// // Simple text (default direction: .top)
/// DSTooltip(style: .simple("Hint text here"))
///
/// // With direction modifier
/// DSTooltip(style: .simple("Hint text here"))
///     .tooltipDirection(.bottom)
///
/// // Rich with title + body
/// DSTooltip(style: .rich(title: "Title", body: "Description...", actionLabel: "Learn more", onAction: {}))
///     .tooltipDirection(.bottom)
/// ```
public struct DSTooltip: View {
    @Environment(\.theme) private var theme

    private let _style: DSTooltipStyle
    private var _direction: DSTooltipDirection = .top

    // MARK: - Minimal init

    public init(style: DSTooltipStyle) {
        self._style = style
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSTooltip(style:) with .tooltipDirection() modifier instead")
    public init(style: DSTooltipStyle, direction: DSTooltipDirection) {
        self._style = style
        self._direction = direction
    }

    // MARK: - Modifiers

    /// Sets the direction the tooltip arrow points toward.
    public func tooltipDirection(_ direction: DSTooltipDirection) -> DSTooltip {
        var copy = self
        copy._direction = direction
        return copy
    }

    // MARK: - Body

    public var body: some View {
        switch _direction {
        case .top:
            VStack(spacing: 0) {
                tooltipContent
                arrow(rotation: 0)
            }
        case .bottom:
            VStack(spacing: 0) {
                arrow(rotation: 180)
                tooltipContent
            }
        case .left:
            HStack(spacing: 0) {
                tooltipContent
                arrow(rotation: 270)
            }
        case .right:
            HStack(spacing: 0) {
                arrow(rotation: 90)
                tooltipContent
            }
        }
    }

    // MARK: - Tooltip Content

    private var tooltipContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch _style {
            case .simple(let text):
                Text(text)
                    .font(theme.typography.caption.font)
                    .tracking(theme.typography.caption.tracking)
                    .foregroundStyle(theme.colors.surfaceNeutral05)
                    .padding(.horizontal, theme.spacing.md)
                    .padding(.vertical, theme.spacing.sm)

            case .rich(let title, let body, let image, let actionLabel, let onAction):
                VStack(alignment: .leading, spacing: 12) {
                    if let image {
                        image
                            .frame(height: 130)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))
                    }

                    VStack(alignment: .leading, spacing: theme.spacing.xs) {
                        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                            Text(title)
                                .font(theme.typography.bodySemiBold.font)
                                .tracking(theme.typography.bodySemiBold.tracking)
                                .foregroundStyle(theme.colors.surfaceNeutral05)

                            Text(body)
                                .font(theme.typography.caption.font)
                                .tracking(theme.typography.caption.tracking)
                                .foregroundStyle(theme.colors.surfaceNeutral05)
                        }

                        if let actionLabel, let onAction {
                            Button(action: onAction) {
                                HStack(spacing: theme.spacing.xs) {
                                    Text(actionLabel)
                                        .font(theme.typography.label.font)
                                        .tracking(theme.typography.label.tracking)
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14))
                                }
                                .foregroundStyle(theme.colors.textNeutral05)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(theme.spacing.md)
            }
        }
        .frame(maxWidth: 240)
        .background(theme.colors.surfacePrimary120)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var cornerRadius: CGFloat {
        switch _style {
        case .simple:
            return theme.radius.sm
        case .rich:
            return theme.radius.md
        }
    }

    // MARK: - Arrow

    private func arrow(rotation: Double) -> some View {
        Triangle()
            .fill(theme.colors.surfacePrimary120)
            .frame(width: 12, height: 6)
            .rotationEffect(.degrees(rotation))
    }
}

// MARK: - Triangle Shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

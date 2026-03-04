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
/// Usage:
/// ```swift
/// // Simple text
/// DSTooltip(style: .simple("Hint text here"), direction: .top)
///
/// // Rich with title + body
/// DSTooltip(
///     style: .rich(title: "Title", body: "Description...", actionLabel: "Learn more", onAction: {}),
///     direction: .bottom
/// )
/// ```
public struct DSTooltip: View {
    @Environment(\.theme) private var theme

    private let style: DSTooltipStyle
    private let direction: DSTooltipDirection

    public init(style: DSTooltipStyle, direction: DSTooltipDirection = .top) {
        self.style = style
        self.direction = direction
    }

    public var body: some View {
        switch direction {
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
            switch style {
            case .simple(let text):
                Text(text)
                    .font(theme.typography.caption.font)
                    .tracking(theme.typography.caption.tracking)
                    .foregroundStyle(theme.colors.surfaceNeutral0_5)
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
                                .foregroundStyle(theme.colors.surfaceNeutral0_5)

                            Text(body)
                                .font(theme.typography.caption.font)
                                .tracking(theme.typography.caption.tracking)
                                .foregroundStyle(theme.colors.surfaceNeutral0_5)
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
                                .foregroundStyle(theme.colors.textNeutral0_5)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(theme.spacing.md)
            }
        }
        .frame(width: 240)
        .background(theme.colors.surfacePrimary120)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var cornerRadius: CGFloat {
        switch style {
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

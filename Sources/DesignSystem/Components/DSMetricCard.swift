import SwiftUI

// MARK: - DSMetricCard

/// A fitness/dashboard stat card with title + icon row, optional value + unit,
/// and an optional content slot (chart, progress circle, etc.).
///
/// Usage:
/// ```swift
/// // With value + unit at bottom
/// DSMetricCard(title: "Calories", icon: .halfCookie, value: "2.248", unit: "kcal",
///     background: theme.colors.surfaceNeutral2, foreground: theme.colors.textNeutral9)
///
/// // With content slot and value
/// DSMetricCard(title: "Heart", icon: .heart, value: "86", unit: "bpm",
///     background: theme.colors.surfaceNeutral3, foreground: theme.colors.textNeutral9) {
///     DSLineChart(...)
/// }
///
/// // Content-only (value embedded in content, e.g. progress circle center)
/// DSMetricCard(title: "Walk", icon: .walking,
///     background: theme.colors.surfacePrimary100, foreground: theme.colors.textNeutral0_5) {
///     DSProgressCircle(...)
/// }
/// ```
public struct DSMetricCard<Content: View>: View {
    @Environment(\.theme) private var theme

    private let title: String
    private let icon: DSIcon
    private let value: String?
    private let unit: String?
    private let background: Color
    private let foreground: Color
    private let content: Content

    public init(
        title: String,
        icon: DSIcon,
        value: String? = nil,
        unit: String? = nil,
        background: Color,
        foreground: Color,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.icon = icon
        self.value = value
        self.unit = unit
        self.background = background
        self.foreground = foreground
        self.content = content()
    }

    public var body: some View {
        DSCard(
            background: background,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Title row
                HStack {
                    Text(title)
                        .font(theme.typography.largeSemiBold.font)
                        .tracking(theme.typography.largeSemiBold.tracking)
                    Spacer()
                    Image(dsIcon: icon)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .foregroundStyle(foreground)

                // Optional content slot
                if Content.self != EmptyView.self {
                    content
                }

                // Optional value + unit
                if let value {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(value)
                            .font(theme.typography.largeSemiBold.font)
                            .tracking(theme.typography.largeSemiBold.tracking)
                        if let unit {
                            Text(unit)
                                .font(theme.typography.tiny.font)
                                .tracking(theme.typography.tiny.tracking)
                        }
                    }
                    .foregroundStyle(foreground)
                }
            }
        }
    }
}

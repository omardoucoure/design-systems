import SwiftUI

// MARK: - DSMetricCard

/// A fitness/dashboard stat card with title + icon row, optional value + unit,
/// and an optional content slot (chart, progress circle, etc.).
///
/// Usage (modifier API):
/// ```swift
/// DSMetricCard(title: "Calories", icon: .halfCookie) {
///     DSLineChart(...)
/// }
/// .metricValue("2.248", unit: "kcal")
/// .metricBackground(theme.colors.surfaceNeutral2)
/// .metricForeground(theme.colors.textNeutral9)
/// ```
public struct DSMetricCard<Content: View>: View {
    @Environment(\.theme) private var theme

    // Core (init-only)
    private let title: String
    private let icon: DSIcon
    private let content: Content

    // Modifier-based visual customization
    private var _value: String?
    private var _unit: String?
    private var _background: Color?
    private var _foreground: Color?

    public init(
        title: String,
        icon: DSIcon,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSMetricCard(title:icon:content:) with .metricValue(), .metricBackground(), .metricForeground() modifiers instead")
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
        self._value = value
        self._unit = unit
        self._background = background
        self._foreground = foreground
        self.content = content()
    }

    // MARK: - Modifiers

    public func metricValue(_ value: String, unit: String? = nil) -> Self {
        var copy = self
        copy._value = value
        copy._unit = unit
        return copy
    }

    public func metricBackground(_ color: Color) -> Self {
        var copy = self
        copy._background = color
        return copy
    }

    public func metricForeground(_ color: Color) -> Self {
        var copy = self
        copy._foreground = color
        return copy
    }

    // MARK: - Body

    public var body: some View {
        let bg = _background ?? theme.colors.surfaceNeutral2
        let fg = _foreground ?? theme.colors.textNeutral9

        DSCard {
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
                .foregroundStyle(fg)

                // Optional content slot
                if Content.self != EmptyView.self {
                    content
                }

                // Optional value + unit
                if let value = _value {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(value)
                            .font(theme.typography.largeSemiBold.font)
                            .tracking(theme.typography.largeSemiBold.tracking)
                        if let unit = _unit {
                            Text(unit)
                                .font(theme.typography.tiny.font)
                                .tracking(theme.typography.tiny.tracking)
                        }
                    }
                    .foregroundStyle(fg)
                }
            }
        }
        .cardBackground(bg)
    }
}

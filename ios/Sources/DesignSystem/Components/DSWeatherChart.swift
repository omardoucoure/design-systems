import SwiftUI

// MARK: - DSWeatherChartData

public struct DSWeatherChartData: Identifiable {
    public let id = UUID()
    public let label: String
    public let value: String
    public let barHeight: CGFloat
    public let isHighlighted: Bool

    public init(label: String, value: String, barHeight: CGFloat, isHighlighted: Bool = false) {
        self.label = label
        self.value = value
        self.barHeight = barHeight
        self.isHighlighted = isHighlighted
    }
}

// MARK: - DSWeatherChart

/// A weather-style chart with thin vertical capsule bars, value labels above,
/// day labels below, and an optional DSLineChart overlay.
///
/// Usage:
/// ```swift
/// DSWeatherChart(
///     data: weekData,
///     linePoints: temperaturePoints,
///     barColor: theme.colors.borderNeutral9_5,
///     highlightColor: theme.brand.primitives.secondary120,
///     lineColor: theme.brand.primitives.secondary120
/// )
/// ```
public struct DSWeatherChart: View {
    @Environment(\.theme) private var theme

    private let data: [DSWeatherChartData]
    private let linePoints: [DSLineChartPoint]
    private let barColor: Color?
    private let barOpacity: Double
    private let highlightColor: Color?
    private let lineColor: Color?
    private let maxBarHeight: CGFloat
    private let barWidth: CGFloat

    public init(
        data: [DSWeatherChartData],
        linePoints: [DSLineChartPoint] = [],
        barColor: Color? = nil,
        barOpacity: Double = 0.6,
        highlightColor: Color? = nil,
        lineColor: Color? = nil,
        maxBarHeight: CGFloat = 174,
        barWidth: CGFloat = 8
    ) {
        self.data = data
        self.linePoints = linePoints
        self.barColor = barColor
        self.barOpacity = barOpacity
        self.highlightColor = highlightColor
        self.lineColor = lineColor
        self.maxBarHeight = maxBarHeight
        self.barWidth = barWidth
    }

    public var body: some View {
        VStack(spacing: theme.spacing.xl) {
            valuesRow
            barsWithLineOverlay
        }
    }

    // MARK: - Values Row

    private var valuesRow: some View {
        HStack(spacing: theme.spacing.lg) {
            ForEach(data) { item in
                Text(item.value)
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(-0.24)
                    .foregroundStyle(theme.colors.textNeutral8)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Bars with Line Overlay

    private var barsWithLineOverlay: some View {
        ZStack(alignment: .bottom) {
            barsRow

            if !linePoints.isEmpty {
                lineOverlay
            }
        }
        .frame(height: maxBarHeight)
    }

    // MARK: - Bars Row

    private var barsRow: some View {
        HStack(spacing: theme.spacing.lg) {
            ForEach(data) { item in
                VStack(spacing: 9) {
                    Spacer(minLength: 0)

                    Capsule()
                        .fill(barFill(for: item))
                        .opacity(item.isHighlighted ? 1.0 : barOpacity)
                        .frame(width: barWidth, height: max(item.barHeight, barWidth))

                    Text(item.label)
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(-0.24)
                        .foregroundStyle(theme.colors.textNeutral8)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Line Overlay

    private var lineOverlay: some View {
        GeometryReader { geo in
            DSLineChart(
                points: linePoints,
                lineColor: lineColor ?? theme.brand.primitives.secondary120,
                shadowColor: lineColor ?? theme.brand.primitives.secondary120,
                lineWidth: 2,
                shadowBlur: 2,
                shadowOpacity: 0.3,
                shadowDamping: 0.35
            )
            .frame(height: maxBarHeight * 0.5)
            .offset(y: -maxBarHeight * 0.15)
        }
        .frame(height: maxBarHeight * 0.5)
        .padding(.bottom, 24)
    }

    // MARK: - Helpers

    private func barFill(for item: DSWeatherChartData) -> Color {
        if item.isHighlighted {
            return highlightColor ?? theme.brand.primitives.secondary120
        }
        return barColor ?? theme.colors.borderNeutral9_5
    }
}

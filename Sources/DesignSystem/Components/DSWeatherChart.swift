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
/// Usage (modifier-based):
/// ```swift
/// DSWeatherChart(data: weekData)
///     .linePoints(temperaturePoints)
///     .barColor(theme.colors.borderNeutral95)
///     .highlightColor(theme.brand.primitives.secondary120)
///     .lineColor(theme.brand.primitives.secondary120)
/// ```
public struct DSWeatherChart: View {
    @Environment(\.theme) private var theme

    private let _data: [DSWeatherChartData]
    private var _linePoints: [DSLineChartPoint] = []
    private var _barColor: Color?
    private var _barOpacity: Double = 0.6
    private var _highlightColor: Color?
    private var _lineColor: Color?
    private var _maxBarHeight: CGFloat = 174
    private var _barWidth: CGFloat = 8

    // MARK: - Minimal init

    public init(data: [DSWeatherChartData]) {
        self._data = data
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSWeatherChart(data:) with modifier methods instead")
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
        self._data = data
        self._linePoints = linePoints
        self._barColor = barColor
        self._barOpacity = barOpacity
        self._highlightColor = highlightColor
        self._lineColor = lineColor
        self._maxBarHeight = maxBarHeight
        self._barWidth = barWidth
    }

    // MARK: - Modifiers

    /// Sets the line chart overlay points.
    public func linePoints(_ points: [DSLineChartPoint]) -> DSWeatherChart {
        var copy = self
        copy._linePoints = points
        return copy
    }

    /// Sets the default bar color for non-highlighted bars.
    public func barColor(_ color: Color) -> DSWeatherChart {
        var copy = self
        copy._barColor = color
        return copy
    }

    /// Sets the opacity for non-highlighted bars.
    public func barOpacity(_ opacity: Double) -> DSWeatherChart {
        var copy = self
        copy._barOpacity = opacity
        return copy
    }

    /// Sets the color for highlighted bars.
    public func highlightColor(_ color: Color) -> DSWeatherChart {
        var copy = self
        copy._highlightColor = color
        return copy
    }

    /// Sets the line chart overlay color.
    public func lineColor(_ color: Color) -> DSWeatherChart {
        var copy = self
        copy._lineColor = color
        return copy
    }

    /// Sets the maximum bar height.
    public func maxBarHeight(_ height: CGFloat) -> DSWeatherChart {
        var copy = self
        copy._maxBarHeight = height
        return copy
    }

    /// Sets the bar width.
    public func barWidth(_ width: CGFloat) -> DSWeatherChart {
        var copy = self
        copy._barWidth = width
        return copy
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: theme.spacing.xl) {
            valuesRow
            barsWithLineOverlay
        }
    }

    // MARK: - Values Row

    private var valuesRow: some View {
        HStack(spacing: theme.spacing.lg) {
            ForEach(_data) { item in
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

            if !_linePoints.isEmpty {
                lineOverlay
            }
        }
        .frame(height: _maxBarHeight)
    }

    // MARK: - Bars Row

    private var barsRow: some View {
        HStack(spacing: theme.spacing.lg) {
            ForEach(_data) { item in
                VStack(spacing: 9) {
                    Spacer(minLength: 0)

                    Capsule()
                        .fill(barFill(for: item))
                        .opacity(item.isHighlighted ? 1.0 : _barOpacity)
                        .frame(width: _barWidth, height: max(item.barHeight, _barWidth))

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
            DSLineChart(points: _linePoints)
                .lineColor(_lineColor ?? theme.brand.primitives.secondary120)
                .shadowColor(_lineColor ?? theme.brand.primitives.secondary120)
                .lineWidth(2)
                .shadowBlur(2)
                .shadowOpacity(0.3)
                .shadowDamping(0.35)
            .frame(height: _maxBarHeight * 0.5)
            .offset(y: -_maxBarHeight * 0.15)
        }
        .frame(height: _maxBarHeight * 0.5)
        .padding(.bottom, 24)
    }

    // MARK: - Helpers

    private func barFill(for item: DSWeatherChartData) -> Color {
        if item.isHighlighted {
            return _highlightColor ?? theme.brand.primitives.secondary120
        }
        return _barColor ?? theme.colors.borderNeutral95
    }
}

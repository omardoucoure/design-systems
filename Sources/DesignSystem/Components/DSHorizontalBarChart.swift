import SwiftUI

// MARK: - DSHorizontalBarChartData

public struct DSHorizontalBarChartData: Identifiable {
    public let id = UUID()
    public let label: String
    public let leftValue: CGFloat
    public let rightValue: CGFloat

    /// - Parameters:
    ///   - label: Center label text (e.g., "90", "80").
    ///   - leftValue: Normalized 0...1 for the left bar width.
    ///   - rightValue: Normalized 0...1 for the right bar width.
    public init(label: String, leftValue: CGFloat, rightValue: CGFloat) {
        self.label = label
        self.leftValue = leftValue
        self.rightValue = rightValue
    }
}

// MARK: - DSHorizontalBarChart

/// A dual horizontal bar chart with left bars (right-aligned), center labels,
/// and right bars (left-aligned). Used for comparing two data sets side by side.
///
/// Usage (modifier API):
/// ```swift
/// DSHorizontalBarChart(data: comparisonRows)
///     .leftColor(theme.brand.primitives.secondary120)
///     .rightColor(theme.colors.borderNeutral95)
///     .rightOpacity(0.75)
/// ```
public struct DSHorizontalBarChart: View {
    @Environment(\.theme) private var theme

    private let data: [DSHorizontalBarChartData]
    var _leftColor: Color?
    var _rightColor: Color?
    var _rightOpacity: Double = 0.75
    var _barHeight: CGFloat = 8
    var _labelWidth: CGFloat = 19

    // MARK: - New Minimal Init

    public init(data: [DSHorizontalBarChartData]) {
        self.data = data
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use DSHorizontalBarChart(data:) with modifier methods instead")
    public init(
        data: [DSHorizontalBarChartData],
        leftColor: Color? = nil,
        rightColor: Color? = nil,
        rightOpacity: Double = 0.75,
        barHeight: CGFloat = 8,
        labelWidth: CGFloat = 19
    ) {
        self.data = data
        self._leftColor = leftColor
        self._rightColor = rightColor
        self._rightOpacity = rightOpacity
        self._barHeight = barHeight
        self._labelWidth = labelWidth
    }

    // MARK: - Modifiers

    public func leftColor(_ color: Color) -> DSHorizontalBarChart {
        var copy = self; copy._leftColor = color; return copy
    }

    public func rightColor(_ color: Color) -> DSHorizontalBarChart {
        var copy = self; copy._rightColor = color; return copy
    }

    public func rightOpacity(_ opacity: Double) -> DSHorizontalBarChart {
        var copy = self; copy._rightOpacity = opacity; return copy
    }

    public func barHeight(_ height: CGFloat) -> DSHorizontalBarChart {
        var copy = self; copy._barHeight = height; return copy
    }

    public func labelWidth(_ width: CGFloat) -> DSHorizontalBarChart {
        var copy = self; copy._labelWidth = width; return copy
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .top, spacing: theme.spacing.xs) {
            leftColumn
            centerLabels
            rightColumn
        }
    }

    // MARK: - Left Column

    private var leftColumn: some View {
        VStack(alignment: .trailing, spacing: theme.spacing.lg) {
            ForEach(data) { item in
                Capsule()
                    .fill(_leftColor ?? theme.brand.primitives.secondary120)
                    .frame(height: _barHeight)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .scaleEffect(x: item.leftValue, anchor: .trailing)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Center Labels

    private var centerLabels: some View {
        VStack(spacing: theme.spacing.lg) {
            ForEach(data) { item in
                Text(item.label)
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(-0.2)
                    .foregroundStyle(theme.colors.textNeutral9)
                    .frame(width: _labelWidth, height: _barHeight)
            }
        }
    }

    // MARK: - Right Column

    private var rightColumn: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            ForEach(data) { item in
                Capsule()
                    .fill(_rightColor ?? theme.colors.borderNeutral95)
                    .opacity(_rightOpacity)
                    .frame(height: _barHeight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scaleEffect(x: item.rightValue, anchor: .leading)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

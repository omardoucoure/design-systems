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
/// Usage:
/// ```swift
/// DSHorizontalBarChart(
///     data: comparisonRows,
///     leftColor: theme.brand.primitives.secondary120,
///     rightColor: theme.colors.borderNeutral9_5
/// )
/// ```
public struct DSHorizontalBarChart: View {
    @Environment(\.theme) private var theme

    private let data: [DSHorizontalBarChartData]
    private let leftColor: Color?
    private let rightColor: Color?
    private let rightOpacity: Double
    private let barHeight: CGFloat
    private let labelWidth: CGFloat

    public init(
        data: [DSHorizontalBarChartData],
        leftColor: Color? = nil,
        rightColor: Color? = nil,
        rightOpacity: Double = 0.75,
        barHeight: CGFloat = 8,
        labelWidth: CGFloat = 19
    ) {
        self.data = data
        self.leftColor = leftColor
        self.rightColor = rightColor
        self.rightOpacity = rightOpacity
        self.barHeight = barHeight
        self.labelWidth = labelWidth
    }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.spacing.xs) {
            // Left bars (right-aligned, grow from right to left)
            leftColumn

            // Center labels
            centerLabels

            // Right bars (left-aligned, grow from left to right)
            rightColumn
        }
    }

    // MARK: - Left Column

    private var leftColumn: some View {
        VStack(alignment: .trailing, spacing: theme.spacing.lg) {
            ForEach(data) { item in
                Capsule()
                    .fill(leftColor ?? theme.brand.primitives.secondary120)
                    .frame(height: barHeight)
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
                    .frame(width: labelWidth, height: barHeight)
            }
        }
    }

    // MARK: - Right Column

    private var rightColumn: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            ForEach(data) { item in
                Capsule()
                    .fill(rightColor ?? theme.colors.borderNeutral9_5)
                    .opacity(rightOpacity)
                    .frame(height: barHeight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scaleEffect(x: item.rightValue, anchor: .leading)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

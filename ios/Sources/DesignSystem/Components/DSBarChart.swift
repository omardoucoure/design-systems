import SwiftUI

// MARK: - Bar Chart Data

public struct DSBarChartData: Identifiable {
    public let id = UUID()
    public let label: String
    public let value: CGFloat

    public init(label: String, value: CGFloat) {
        self.label = label
        self.value = value
    }
}

// MARK: - DSBarChart

/// A simple bar chart with rounded-top bars and labels below.
///
/// Usage:
/// ```swift
/// DSBarChart(
///     data: [
///         DSBarChartData(label: "Mon", value: 0.4),
///         DSBarChartData(label: "Tue", value: 0.8),
///     ],
///     barColor: theme.colors.surfaceNeutral2,
///     highlightColor: theme.colors.surfaceSecondary100,
///     highlightIndex: 3
/// )
/// ```
public struct DSBarChart: View {
    @Environment(\.theme) private var theme

    private let data: [DSBarChartData]
    private let barColor: Color?
    private let highlightColor: Color?
    private let highlightIndex: Int?
    private let maxHeight: CGFloat

    public init(
        data: [DSBarChartData],
        barColor: Color? = nil,
        highlightColor: Color? = nil,
        highlightIndex: Int? = nil,
        maxHeight: CGFloat = 120
    ) {
        self.data = data
        self.barColor = barColor
        self.highlightColor = highlightColor
        self.highlightIndex = highlightIndex
        self.maxHeight = maxHeight
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: theme.spacing.xs) {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: theme.spacing.xxs) {
                    let isHighlighted = index == highlightIndex
                    let barHeight = max(item.value * maxHeight, 4)

                    UnevenRoundedRectangle(
                        topLeadingRadius: theme.radius.xs,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: theme.radius.xs
                    )
                    .fill(isHighlighted
                          ? (highlightColor ?? theme.colors.surfaceSecondary100)
                          : (barColor ?? theme.colors.surfaceNeutral3))
                    .frame(height: barHeight)

                    Text(item.label)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(
                            theme.colors.textNeutral9
                                .opacity(isHighlighted ? 1.0 : theme.colors.textOpacity75)
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

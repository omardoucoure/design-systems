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
/// Usage (modifier API):
/// ```swift
/// DSBarChart(data: weeklySteps)
///     .barColor(theme.colors.surfaceNeutral2)
///     .highlightColor(theme.colors.surfaceSecondary100)
///     .highlightIndex(3)
///     .maxHeight(120)
/// ```
public struct DSBarChart: View {
    @Environment(\.theme) private var theme

    private let data: [DSBarChartData]
    var _barColor: Color?
    var _highlightColor: Color?
    var _highlightIndex: Int?
    var _maxHeight: CGFloat = 120

    // MARK: - New Minimal Init

    public init(data: [DSBarChartData]) {
        self.data = data
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use DSBarChart(data:) with modifier methods instead")
    public init(
        data: [DSBarChartData],
        barColor: Color? = nil,
        highlightColor: Color? = nil,
        highlightIndex: Int? = nil,
        maxHeight: CGFloat = 120
    ) {
        self.data = data
        self._barColor = barColor
        self._highlightColor = highlightColor
        self._highlightIndex = highlightIndex
        self._maxHeight = maxHeight
    }

    // MARK: - Modifiers

    public func barColor(_ color: Color) -> DSBarChart {
        var copy = self; copy._barColor = color; return copy
    }

    public func highlightColor(_ color: Color) -> DSBarChart {
        var copy = self; copy._highlightColor = color; return copy
    }

    public func highlightIndex(_ index: Int?) -> DSBarChart {
        var copy = self; copy._highlightIndex = index; return copy
    }

    public func maxHeight(_ height: CGFloat) -> DSBarChart {
        var copy = self; copy._maxHeight = height; return copy
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .bottom, spacing: theme.spacing.xs) {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: theme.spacing.xxs) {
                    let isHighlighted = index == _highlightIndex
                    let barHeight = max(item.value * _maxHeight, 4)

                    UnevenRoundedRectangle(
                        topLeadingRadius: theme.radius.xs,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: theme.radius.xs
                    )
                    .fill(isHighlighted
                          ? (_highlightColor ?? theme.colors.surfaceSecondary100)
                          : (_barColor ?? theme.colors.surfaceNeutral3))
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

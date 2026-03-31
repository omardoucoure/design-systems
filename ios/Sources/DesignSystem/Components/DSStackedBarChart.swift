import SwiftUI

// MARK: - DSStackedBarChartSegment

public struct DSStackedBarChartSegment {
    public let height: CGFloat
    public let color: Color

    public init(height: CGFloat, color: Color) {
        self.height = height
        self.color = color
    }
}

// MARK: - DSStackedBarChartColumn

public struct DSStackedBarChartColumn {
    public let segments: [DSStackedBarChartSegment]

    public init(segments: [DSStackedBarChartSegment]) {
        self.segments = segments
    }
}

// MARK: - DSStackedBarChart

/// Stacked vertical bar chart with optional time labels beneath each column.
///
/// Usage (modifier API):
/// ```swift
/// DSStackedBarChart(columns: chartColumns)
///     .timeLabels(["00:00", "12:00", "23:59"])
///     .chartHeight(129)
///     .barWidth(4)
///     .segmentGap(6)
/// ```
public struct DSStackedBarChart: View {
    @Environment(\.theme) private var theme

    private let columns: [DSStackedBarChartColumn]
    var _timeLabels: [LocalizedStringKey] = []
    var _chartHeight: CGFloat = 129
    var _barWidth: CGFloat = 4
    var _segmentGap: CGFloat = 6

    // MARK: - New Minimal Init

    public init(columns: [DSStackedBarChartColumn]) {
        self.columns = columns
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use DSStackedBarChart(columns:) with modifier methods instead")
    public init(
        columns: [DSStackedBarChartColumn],
        timeLabels: [LocalizedStringKey] = [],
        chartHeight: CGFloat = 129,
        barWidth: CGFloat = 4,
        segmentGap: CGFloat = 6
    ) {
        self.columns = columns
        self._timeLabels = timeLabels
        self._chartHeight = chartHeight
        self._barWidth = barWidth
        self._segmentGap = segmentGap
    }

    // MARK: - Modifiers

    public func timeLabels(_ labels: [LocalizedStringKey]) -> DSStackedBarChart {
        var copy = self; copy._timeLabels = labels; return copy
    }

    public func chartHeight(_ height: CGFloat) -> DSStackedBarChart {
        var copy = self; copy._chartHeight = height; return copy
    }

    public func barWidth(_ width: CGFloat) -> DSStackedBarChart {
        var copy = self; copy._barWidth = width; return copy
    }

    public func segmentGap(_ gap: CGFloat) -> DSStackedBarChart {
        var copy = self; copy._segmentGap = gap; return copy
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: theme.spacing.xs) {
            // Chart bars
            HStack(alignment: .bottom) {
                ForEach(Array(columns.enumerated()), id: \.offset) { _, column in
                    Spacer(minLength: 0)
                    VStack(spacing: _segmentGap) {
                        ForEach(Array(column.segments.enumerated()), id: \.offset) { _, segment in
                            RoundedRectangle(cornerRadius: 100)
                                .fill(segment.color)
                                .frame(width: _barWidth, height: segment.height)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
            .frame(height: _chartHeight)
            .frame(maxWidth: .infinity)

            // Time labels
            if !_timeLabels.isEmpty {
                HStack(spacing: 0) {
                    ForEach(Array(_timeLabels.enumerated()), id: \.offset) { _, label in
                        Text(label)
                            .font(theme.typography.bodyRegular.font)
                            .tracking(theme.typography.bodyRegular.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                            .frame(maxWidth: .infinity)
                            .padding(theme.spacing.md)
                    }
                }
            }
        }
    }
}

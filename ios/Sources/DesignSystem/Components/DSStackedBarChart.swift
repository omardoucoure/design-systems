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

public struct DSStackedBarChart: View {
    @Environment(\.theme) private var theme

    private let columns: [DSStackedBarChartColumn]
    private let timeLabels: [LocalizedStringKey]
    private let chartHeight: CGFloat
    private let barWidth: CGFloat
    private let segmentGap: CGFloat

    public init(
        columns: [DSStackedBarChartColumn],
        timeLabels: [LocalizedStringKey] = [],
        chartHeight: CGFloat = 129,
        barWidth: CGFloat = 4,
        segmentGap: CGFloat = 6
    ) {
        self.columns = columns
        self.timeLabels = timeLabels
        self.chartHeight = chartHeight
        self.barWidth = barWidth
        self.segmentGap = segmentGap
    }

    public var body: some View {
        VStack(spacing: theme.spacing.xs) {
            // Chart bars
            HStack(alignment: .bottom) {
                ForEach(Array(columns.enumerated()), id: \.offset) { _, column in
                    Spacer(minLength: 0)
                    VStack(spacing: segmentGap) {
                        ForEach(Array(column.segments.enumerated()), id: \.offset) { _, segment in
                            RoundedRectangle(cornerRadius: 100)
                                .fill(segment.color)
                                .frame(width: barWidth, height: segment.height)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
            .frame(height: chartHeight)
            .frame(maxWidth: .infinity)

            // Time labels
            if !timeLabels.isEmpty {
                HStack(spacing: 0) {
                    ForEach(Array(timeLabels.enumerated()), id: \.offset) { _, label in
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

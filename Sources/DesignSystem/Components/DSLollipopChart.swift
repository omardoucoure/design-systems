import SwiftUI

// MARK: - DSLollipopChartItem

public struct DSLollipopChartItem {
    public let label: String
    public let height: CGFloat

    public init(label: String, height: CGFloat) {
        self.label = label
        self.height = height
    }
}

// MARK: - DSLollipopChart

/// A circle-top bar chart with rotated month labels.
/// One bar can be highlighted (wider circle + stem, with a value label above).
///
/// Usage:
/// ```swift
/// DSLollipopChart(
///     data: [DSLollipopChartItem(label: "Jan", height: 25), ...],
///     highlightIndex: 9,
///     highlightLabel: "$8,628"
/// )
/// ```
public struct DSLollipopChart: View {
    @Environment(\.theme) private var theme

    private let data: [DSLollipopChartItem]
    private let highlightIndex: Int?
    private let highlightLabel: String?
    private let color: Color?

    public init(
        data: [DSLollipopChartItem],
        highlightIndex: Int? = nil,
        highlightLabel: String? = nil,
        color: Color? = nil
    ) {
        self.data = data
        self.highlightIndex = highlightIndex
        self.highlightLabel = highlightLabel
        self.color = color
    }

    public var body: some View {
        let barColor = color ?? theme.colors.surfaceSecondary100
        let maxHeight = data.map(\.height).max() ?? 1

        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                let isHighlighted = index == highlightIndex
                Spacer(minLength: 0)
                VStack(spacing: 9) {
                    // Value label above highlighted bar
                    if isHighlighted, let highlightLabel {
                        Text(highlightLabel)
                            .font(theme.typography.largeSemiBold.font)
                            .tracking(theme.typography.largeSemiBold.tracking)
                            .foregroundStyle(theme.colors.textNeutral8)
                    }

                    // Circle + stem
                    VStack(spacing: 0) {
                        Circle()
                            .fill(barColor)
                            .frame(
                                width: isHighlighted ? 32 : 12,
                                height: isHighlighted ? 32 : 12
                            )
                        RoundedRectangle(cornerRadius: theme.radius.xxs)
                            .fill(barColor)
                            .frame(width: isHighlighted ? 4 : 2, height: item.height)
                    }

                    // Rotated label
                    Text(item.label)
                        .font(theme.typography.tiny.font)
                        .tracking(theme.typography.tiny.tracking)
                        .foregroundStyle(theme.colors.textNeutral8)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 15, height: 20)
                }
                Spacer(minLength: 0)
            }
        }
        .frame(height: maxHeight + 80)
    }
}

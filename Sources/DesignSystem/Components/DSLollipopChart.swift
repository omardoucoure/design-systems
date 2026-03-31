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
/// Usage (modifier API):
/// ```swift
/// DSLollipopChart(data: monthlyData)
///     .highlightIndex(9)
///     .highlightLabel("$8,628")
///     .color(theme.colors.surfaceSecondary100)
/// ```
public struct DSLollipopChart: View {
    @Environment(\.theme) private var theme

    private let data: [DSLollipopChartItem]
    var _highlightIndex: Int?
    var _highlightLabel: String?
    var _color: Color?

    // MARK: - New Minimal Init

    public init(data: [DSLollipopChartItem]) {
        self.data = data
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use DSLollipopChart(data:) with modifier methods instead")
    public init(
        data: [DSLollipopChartItem],
        highlightIndex: Int? = nil,
        highlightLabel: String? = nil,
        color: Color? = nil
    ) {
        self.data = data
        self._highlightIndex = highlightIndex
        self._highlightLabel = highlightLabel
        self._color = color
    }

    // MARK: - Modifiers

    public func highlightIndex(_ index: Int?) -> DSLollipopChart {
        var copy = self; copy._highlightIndex = index; return copy
    }

    public func highlightLabel(_ label: String?) -> DSLollipopChart {
        var copy = self; copy._highlightLabel = label; return copy
    }

    public func color(_ color: Color) -> DSLollipopChart {
        var copy = self; copy._color = color; return copy
    }

    // MARK: - Body

    public var body: some View {
        let barColor = _color ?? theme.colors.surfaceSecondary100
        let maxHeight = data.map(\.height).max() ?? 1

        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                let isHighlighted = index == _highlightIndex
                Spacer(minLength: 0)
                VStack(spacing: 9) {
                    // Value label above highlighted bar
                    if isHighlighted, let highlightLabel = _highlightLabel {
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

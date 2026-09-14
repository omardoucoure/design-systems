import SwiftUI

public struct DSFlowLayout: Layout {
    private let spacing: CGFloat

    public init(spacing: CGFloat = DSFlowLayout.Metrics.defaultSpacing) {
        self.spacing = spacing
    }

    public enum Metrics {
        public static let defaultSpacing = SpacingTokens.shared.xs
    }

    public enum Rows {
        public static func make(widths: [CGFloat], containerWidth: CGFloat, spacing: CGFloat) -> [[Int]] {
            var rows: [[Int]] = []
            var current: [Int] = []
            var used: CGFloat = 0

            for (index, width) in widths.enumerated() {
                let needed = current.isEmpty ? width : used + spacing + width
                if !current.isEmpty && needed > containerWidth {
                    rows.append(current)
                    current = [index]
                    used = width
                } else {
                    current.append(index)
                    used = needed
                }
            }

            if !current.isEmpty { rows.append(current) }
            return rows
        }

        public static func size(sizes: [CGSize], containerWidth: CGFloat, spacing: CGFloat) -> CGSize {
            let grouped = make(widths: sizes.map(\.width), containerWidth: containerWidth, spacing: spacing)
            guard !grouped.isEmpty else { return .zero }

            var height: CGFloat = 0
            var width: CGFloat = 0
            for (index, row) in grouped.enumerated() {
                let rowHeight = row.map { sizes[$0].height }.max() ?? 0
                let rowWidth = row.reduce(CGFloat(0)) { $0 + sizes[$1].width }
                    + spacing * CGFloat(max(0, row.count - 1))
                height += rowHeight
                if index > 0 { height += spacing }
                width = max(width, rowWidth)
            }
            return CGSize(width: width, height: height)
        }
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let containerWidth = proposal.width ?? .infinity
        let measured = Rows.size(sizes: sizes, containerWidth: containerWidth, spacing: spacing)
        guard let width = proposal.width else { return measured }
        return CGSize(width: width, height: measured.height)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize,
                              subviews: Subviews, cache: inout Void) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let grouped = Rows.make(widths: sizes.map(\.width), containerWidth: bounds.width, spacing: spacing)

        var y = bounds.minY
        for row in grouped {
            var x = bounds.minX
            let rowHeight = row.map { sizes[$0].height }.max() ?? 0
            for index in row {
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(sizes[index]))
                x += sizes[index].width + spacing
            }
            y += rowHeight + spacing
        }
    }
}

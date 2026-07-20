import SwiftUI

public struct DSSparkline: View {
    @Environment(\.theme) private var theme

    private let values: [Double]
    var _barColors: [Color] = []
    var _barRadius: CGFloat = 6
    var _barGap: CGFloat = 6

    public init(values: [Double]) {
        self.values = values
    }

    public func barColors(_ colors: [Color]) -> DSSparkline {
        var copy = self
        copy._barColors = colors
        return copy
    }

    public func barRadius(_ radius: CGFloat) -> DSSparkline {
        var copy = self
        copy._barRadius = radius
        return copy
    }

    public func barGap(_ gap: CGFloat) -> DSSparkline {
        var copy = self
        copy._barGap = gap
        return copy
    }

    var clampedValues: [Double] {
        values.map { min(max($0, 0), 1) }
    }

    public var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .bottom, spacing: _barGap) {
                ForEach(Array(clampedValues.enumerated()), id: \.offset) { index, value in
                    RoundedRectangle(cornerRadius: _barRadius)
                        .fill(color(at: index))
                        .frame(height: proxy.size.height * value)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: proxy.size.height, alignment: .bottom)
        }
    }

    private func color(at index: Int) -> Color {
        guard _barColors.indices.contains(index) else {
            return theme.colors.surfaceSecondary100
        }
        return _barColors[index]
    }
}

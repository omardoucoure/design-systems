import SwiftUI

public struct DSStepDots: View {
    @Environment(\.theme) private var theme

    private let count: Int
    private let currentIndex: Int
    private var _fillColor: Color?

    public init(count: Int, currentIndex: Int) {
        self.count = count
        self.currentIndex = currentIndex
    }

    public func fillColor(_ color: Color) -> Self {
        var copy = self
        copy._fillColor = color
        return copy
    }

    public enum Geometry {
        public static func clamped(current: Int, count: Int) -> Int {
            guard count > 0 else { return 0 }
            return min(max(current, 0), count - 1)
        }

        public static func isActive(index: Int, current: Int) -> Bool {
            index == current
        }

        public static func isComplete(index: Int, current: Int) -> Bool {
            index < current
        }

        public static func progress(current: Int, count: Int) -> Double {
            guard count > 0 else { return 0 }
            return Double(clamped(current: current, count: count) + 1) / Double(count)
        }
    }

    private var metrics: ProductDetailHeroComponentTokens { theme.components.productDetailHero }
    private var fill: Color { _fillColor ?? theme.colors.surfacePrimary120 }

    public var body: some View {
        HStack(spacing: theme.spacing.xs) {
            ForEach(0..<max(count, 0), id: \.self) { index in
                Capsule()
                    .fill(isFilled(index) ? fill : theme.colors.borderNeutral3)
                    .frame(
                        width: Geometry.isActive(index: index, current: current)
                            ? metrics.dotActiveWidth
                            : metrics.dotSize,
                        height: metrics.dotSize
                    )
                    .animation(.spring(response: 0.35, dampingFraction: 0.85), value: current)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityValue(Text(verbatim: "\(current + 1)/\(max(count, 1))"))
    }

    private var current: Int { Geometry.clamped(current: currentIndex, count: count) }

    private func isFilled(_ index: Int) -> Bool {
        Geometry.isActive(index: index, current: current)
            || Geometry.isComplete(index: index, current: current)
    }
}

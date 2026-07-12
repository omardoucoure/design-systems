import SwiftUI

public struct DSValueSlider: View {
    @Environment(\.theme) private var theme

    @Binding private var value: Int
    private let range: ClosedRange<Int>
    private var _minLabel: LocalizedStringKey?
    private var _maxLabel: LocalizedStringKey?

    public init(value: Binding<Int>, in range: ClosedRange<Int>) {
        self._value = value
        self.range = range
    }

    public func minLabel(_ label: LocalizedStringKey) -> Self {
        var copy = self
        copy._minLabel = label
        return copy
    }

    public func maxLabel(_ label: LocalizedStringKey) -> Self {
        var copy = self
        copy._maxLabel = label
        return copy
    }

    private let knobSize: CGFloat = 28
    private let trackHeight: CGFloat = 6

    public var body: some View {
        VStack(spacing: theme.spacing.xs) {
            track
            if _minLabel != nil || _maxLabel != nil {
                HStack {
                    if let _minLabel {
                        Text(_minLabel)
                            .typographyStyle(theme.typography.small)
                            .foregroundStyle(theme.colors.textNeutral8)
                    }
                    Spacer(minLength: 0)
                    if let _maxLabel {
                        Text(_maxLabel)
                            .typographyStyle(theme.typography.small)
                            .foregroundStyle(theme.colors.textNeutral8)
                    }
                }
            }
        }
    }

    private var track: some View {
        GeometryReader { geo in
            let span = max(geo.size.width - knobSize, 1)
            let steps = max(range.upperBound - range.lowerBound, 1)
            let fraction = Double(value - range.lowerBound) / Double(steps)
            let knobX = span * fraction

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(theme.colors.surfaceNeutral3)
                    .frame(height: trackHeight)

                Capsule()
                    .fill(theme.colors.surfacePrimary120)
                    .frame(width: knobX + knobSize / 2, height: trackHeight)

                Circle()
                    .fill(theme.colors.surfaceNeutral05)
                    .frame(width: knobSize, height: knobSize)
                    .overlay(Circle().strokeBorder(theme.colors.borderNeutral3, lineWidth: 1.5))
                    .shadow(color: .black.opacity(0.12), radius: 3, y: 1)
                    .offset(x: knobX)
            }
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { g in
                        let clampedX = min(max(0, g.location.x - knobSize / 2), span)
                        let raw = Double(range.lowerBound) + (clampedX / span) * Double(steps)
                        let next = Int(raw.rounded())
                        if next != value {
                            value = min(max(range.lowerBound, next), range.upperBound)
                        }
                    }
            )
        }
        .frame(height: knobSize)
    }
}

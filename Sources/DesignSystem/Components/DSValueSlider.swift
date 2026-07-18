import SwiftUI

public struct DSValueSlider: View {
    @Environment(\.theme) private var theme

    @Binding private var value: Int?
    private let range: ClosedRange<Int>
    private var _minLabel: LocalizedStringKey?
    private var _maxLabel: LocalizedStringKey?
    private var _fillColor: Color?

    public init(value: Binding<Int>, in range: ClosedRange<Int>) {
        self._value = Binding(get: { value.wrappedValue }, set: { value.wrappedValue = $0 ?? value.wrappedValue })
        self.range = range
    }

    public init(value: Binding<Int?>, in range: ClosedRange<Int>) {
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

    public func fillColor(_ color: Color) -> Self {
        var copy = self
        copy._fillColor = color
        return copy
    }

    private let knobSize: CGFloat = 28
    private let trackHeight: CGFloat = 8

    private var fill: Color { _fillColor ?? theme.colors.surfacePrimary120 }

    enum Geometry {
        static func showsKnob(value: Int?) -> Bool { true }

        static func showsFilledTrack(value: Int?) -> Bool { value != nil }

        static func knobFraction(value: Int?, in range: ClosedRange<Int>) -> Double {
            let steps = Double(max(range.upperBound - range.lowerBound, 1))
            guard let value else { return 0.5 }
            return Double(value - range.lowerBound) / steps
        }
    }

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
            let fraction = Geometry.knobFraction(value: value, in: range)
            let knobX = span * fraction
            let knobStroke = Geometry.showsFilledTrack(value: value) ? fill : theme.colors.borderNeutral95

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(theme.colors.surfaceNeutral3)
                    .frame(height: trackHeight)

                if Geometry.showsFilledTrack(value: value) {
                    Capsule()
                        .fill(fill)
                        .frame(width: knobX + knobSize / 2, height: trackHeight)
                }

                if Geometry.showsKnob(value: value) {
                    Circle()
                        .fill(theme.colors.surfaceNeutral05)
                        .frame(width: knobSize, height: knobSize)
                        .overlay(Circle().strokeBorder(knobStroke, lineWidth: 2))
                        .shadow(color: .black.opacity(0.15), radius: 3, y: 1)
                        .offset(x: knobX)
                }
            }
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { g in
                        let clampedX = min(max(0, g.location.x - knobSize / 2), span)
                        let raw = Double(range.lowerBound) + (clampedX / span) * Double(steps)
                        let next = min(max(range.lowerBound, Int(raw.rounded())), range.upperBound)
                        if next != value {
                            value = next
                        }
                    }
            )
        }
        .frame(height: knobSize)
    }
}

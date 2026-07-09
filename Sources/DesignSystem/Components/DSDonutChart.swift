import SwiftUI

public struct DSDonutSegment: Identifiable {
    public let id = UUID()
    public let label: LocalizedStringKey
    public let value: Double
    public let color: Color

    public init(label: LocalizedStringKey, value: Double, color: Color) {
        self.label = label
        self.value = value
        self.color = color
    }
}

public struct DSDonutChart: View {
    @Environment(\.theme) private var theme

    private let segments: [DSDonutSegment]
    private let centerLabel: LocalizedStringKey
    private let diameter: CGFloat
    private let thickness: CGFloat

    public init(
        segments: [DSDonutSegment],
        centerLabel: LocalizedStringKey,
        diameter: CGFloat = 96,
        thickness: CGFloat = 16
    ) {
        self.segments = segments
        self.centerLabel = centerLabel
        self.diameter = diameter
        self.thickness = thickness
    }

    public var body: some View {
        HStack(spacing: theme.spacing.md) {
            ring
            legend
        }
    }

    private var total: Double {
        max(segments.reduce(0) { $0 + $1.value }, 0.0001)
    }

    private var ring: some View {
        ZStack {
            ForEach(Array(zip(segments, arcs).enumerated()), id: \.offset) { _, pair in
                Circle()
                    .trim(from: pair.1.start, to: pair.1.end)
                    .stroke(pair.0.color, style: StrokeStyle(lineWidth: thickness, lineCap: .butt))
                    .rotationEffect(.degrees(-90))
            }

            Text(centerLabel)
                .font(theme.typography.h6.font)
                .tracking(theme.typography.h6.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
        }
        .frame(width: diameter, height: diameter)
        .padding(thickness / 2)
    }

    private var arcs: [(start: CGFloat, end: CGFloat)] {
        var running: Double = 0
        return segments.map { segment in
            let start = running / total
            running += segment.value
            let end = running / total
            return (CGFloat(start), CGFloat(end))
        }
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            ForEach(segments) { segment in
                HStack(spacing: theme.spacing.xs) {
                    Circle()
                        .fill(segment.color)
                        .frame(width: 8, height: 8)
                    Text(segment.label)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
            }
        }
    }
}

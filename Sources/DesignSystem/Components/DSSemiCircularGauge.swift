import SwiftUI

// MARK: - DSSemiCircularGaugeSegment

/// A segment of the semi-circular gauge arc.
public struct DSSemiCircularGaugeSegment {
    /// Fraction of the gauge arc this segment occupies (0...1, total should sum to ≤ 1).
    public let fraction: CGFloat
    /// Stroke color for this segment.
    public let color: Color

    public init(fraction: CGFloat, color: Color) {
        self.fraction = fraction
        self.color = color
    }
}

// MARK: - DSSemiCircularGauge

/// A semi-circular gauge with thick arc segments, perimeter dots, and a content slot.
///
/// The gauge opens downward — arcs span from lower-left over the top to lower-right.
/// Geometry is derived from Figma's exact dot positions to ensure pixel-accurate rendering.
///
/// Usage:
/// ```swift
/// DSSemiCircularGauge(
///     segments: [
///         .init(fraction: 0.55, color: theme.colors.textNeutral9),
///         .init(fraction: 0.22, color: theme.colors.surfaceSecondary100),
///     ]
/// ) {
///     Text("Center content")
/// }
/// ```
public struct DSSemiCircularGauge<Content: View>: View {
    private let segments: [DSSemiCircularGaugeSegment]
    private let dotCount: Int
    private let dotRadius: CGFloat
    private let dotColor: Color?
    private let strokeWidth: CGFloat
    private let gapDegrees: CGFloat
    private let content: Content

    /// - Parameters:
    ///   - segments: Arc segments drawn from left to right over the top.
    ///   - dotCount: Number of dots around the perimeter (default 9).
    ///   - dotRadius: Radius of each dot (default 2.5).
    ///   - dotColor: Color of the dots (defaults to textNeutral9 @ 35%).
    ///   - strokeWidth: Width of the arc strokes (default 14).
    ///   - gapDegrees: Gap in degrees between segments (default 4).
    ///   - content: Center content view.
    public init(
        segments: [DSSemiCircularGaugeSegment],
        dotCount: Int = 9,
        dotRadius: CGFloat = 2.5,
        dotColor: Color? = nil,
        strokeWidth: CGFloat = 14,
        gapDegrees: CGFloat = 4,
        @ViewBuilder content: () -> Content
    ) {
        self.segments = segments
        self.dotCount = dotCount
        self.dotRadius = dotRadius
        self.dotColor = dotColor
        self.strokeWidth = strokeWidth
        self.gapDegrees = gapDegrees
        self.content = content()
    }

    public var body: some View {
        ZStack {
            Canvas { context, size in
                drawGauge(context: &context, size: size)
            }

            content
        }
    }

    private func drawGauge(context: inout GraphicsContext, size: CGSize) {
        // Figma reference: 304×244 container, center ~(152, 136), dot orbit ~122px.
        // SwiftUI Canvas: 0° = right (3 o'clock), 90° = down, angles go clockwise.
        //
        // The gauge must fit within the given frame without clipping.
        // Inset by strokeWidth/2 + dotRadius so strokes and dots stay inside bounds.
        let inset = strokeWidth / 2 + dotRadius
        let availableWidth = size.width - inset * 2
        let availableHeight = size.height - inset * 2

        // Dot orbit radius: sized so the full arc (including bottom opening) fits.
        // The arc spans 240° with a 120° opening at the bottom.
        // The lowest dot sits at 150° (lower-left) and 390° (lower-right).
        // sin(30°) = 0.5, so the bottom of the arc extends 0.5 * radius below center.
        // Top of arc extends radius above center.
        // Total vertical span from top to bottom-dot = radius + 0.5 * radius = 1.5 * radius.
        // So: 1.5 * radius ≤ availableHeight → radius ≤ availableHeight / 1.5
        // Also: 2 * radius ≤ availableWidth → radius ≤ availableWidth / 2
        let dotOrbitRadius = min(availableWidth / 2, availableHeight / 1.5)

        // Center: horizontally centered, vertically positioned so top of arc has room.
        let center = CGPoint(x: size.width * 0.5, y: inset + dotOrbitRadius)

        // Arc spans from 150° (lower-left) clockwise to 390° (lower-right) = 240° sweep
        let startAngle: CGFloat = 150
        let arcSpan: CGFloat = 240

        // 1. Draw dots evenly along the arc
        if dotCount > 1 {
            let resolvedDotColor = dotColor ?? Color(red: 0.16, green: 0.16, blue: 0.15).opacity(0.35)
            let dotStep = arcSpan / CGFloat(dotCount - 1)
            for i in 0..<dotCount {
                let angleDeg = startAngle + CGFloat(i) * dotStep
                let rad = angleDeg * .pi / 180
                let dotCenter = CGPoint(
                    x: center.x + dotOrbitRadius * cos(rad),
                    y: center.y + dotOrbitRadius * sin(rad)
                )
                let dotPath = Path(ellipseIn: CGRect(
                    x: dotCenter.x - dotRadius,
                    y: dotCenter.y - dotRadius,
                    width: dotRadius * 2,
                    height: dotRadius * 2
                ))
                context.fill(dotPath, with: .color(resolvedDotColor))
            }
        }

        // 2. Draw arc segments just inside the dot orbit
        let arcRadius = dotOrbitRadius * 0.88
        let totalGap = gapDegrees * CGFloat(max(segments.count - 1, 0))
        let usableArc = arcSpan - totalGap
        var currentAngle = startAngle

        let style = StrokeStyle(lineWidth: strokeWidth, lineCap: .round)

        for (index, segment) in segments.enumerated() {
            let segmentArc = usableArc * segment.fraction

            var arcPath = Path()
            arcPath.addArc(
                center: center,
                radius: arcRadius,
                startAngle: .degrees(Double(currentAngle)),
                endAngle: .degrees(Double(currentAngle + segmentArc)),
                clockwise: false
            )
            context.stroke(arcPath, with: .color(segment.color), style: style)

            currentAngle += segmentArc
            if index < segments.count - 1 {
                currentAngle += gapDegrees
            }
        }
    }
}

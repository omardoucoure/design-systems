import SwiftUI

// MARK: - DSSemiCircularGaugeSegment

/// A segment of the semi-circular gauge arc.
public struct DSSemiCircularGaugeSegment {
    /// Fraction of the gauge arc this segment occupies (0...1, total should sum to <= 1).
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
/// Usage (modifier-based):
/// ```swift
/// DSSemiCircularGauge(
///     segments: [
///         .init(fraction: 0.55, color: theme.colors.textNeutral9),
///         .init(fraction: 0.22, color: theme.colors.surfaceSecondary100),
///     ]
/// ) {
///     Text("Center content")
/// }
/// .gaugeDotCount(12)
/// .gaugeStrokeWidth(16)
/// ```
public struct DSSemiCircularGauge<Content: View>: View {
    private let _segments: [DSSemiCircularGaugeSegment]
    private let _content: Content
    private var _dotCount: Int = 9
    private var _dotRadius: CGFloat = 2.5
    private var _dotColor: Color?
    private var _strokeWidth: CGFloat = 14
    private var _gapDegrees: CGFloat = 4

    // MARK: - Minimal init

    public init(
        segments: [DSSemiCircularGaugeSegment],
        @ViewBuilder content: () -> Content
    ) {
        self._segments = segments
        self._content = content()
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSSemiCircularGauge(segments:content:) with modifier methods instead")
    public init(
        segments: [DSSemiCircularGaugeSegment],
        dotCount: Int,
        dotRadius: CGFloat = 2.5,
        dotColor: Color? = nil,
        strokeWidth: CGFloat = 14,
        gapDegrees: CGFloat = 4,
        @ViewBuilder content: () -> Content
    ) {
        self._segments = segments
        self._content = content()
        self._dotCount = dotCount
        self._dotRadius = dotRadius
        self._dotColor = dotColor
        self._strokeWidth = strokeWidth
        self._gapDegrees = gapDegrees
    }

    // MARK: - Modifiers

    /// Sets the number of dots around the perimeter.
    public func gaugeDotCount(_ count: Int) -> DSSemiCircularGauge {
        var copy = self
        copy._dotCount = count
        return copy
    }

    /// Sets the radius of each perimeter dot.
    public func gaugeDotRadius(_ radius: CGFloat) -> DSSemiCircularGauge {
        var copy = self
        copy._dotRadius = radius
        return copy
    }

    /// Sets the color of the perimeter dots.
    public func gaugeDotColor(_ color: Color) -> DSSemiCircularGauge {
        var copy = self
        copy._dotColor = color
        return copy
    }

    /// Sets the width of the arc strokes.
    public func gaugeStrokeWidth(_ width: CGFloat) -> DSSemiCircularGauge {
        var copy = self
        copy._strokeWidth = width
        return copy
    }

    /// Sets the gap in degrees between arc segments.
    public func gaugeGapDegrees(_ degrees: CGFloat) -> DSSemiCircularGauge {
        var copy = self
        copy._gapDegrees = degrees
        return copy
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            Canvas { context, size in
                drawGauge(context: &context, size: size)
            }

            _content
        }
    }

    private func drawGauge(context: inout GraphicsContext, size: CGSize) {
        // Figma reference: 304x244 container, center ~(152, 136), dot orbit ~122px.
        // SwiftUI Canvas: 0 deg = right (3 o'clock), 90 deg = down, angles go clockwise.
        //
        // The gauge must fit within the given frame without clipping.
        // Inset by strokeWidth/2 + dotRadius so strokes and dots stay inside bounds.
        let inset = _strokeWidth / 2 + _dotRadius
        let availableWidth = size.width - inset * 2
        let availableHeight = size.height - inset * 2

        // Dot orbit radius: sized so the full arc (including bottom opening) fits.
        // The arc spans 240 deg with a 120 deg opening at the bottom.
        // The lowest dot sits at 150 deg (lower-left) and 390 deg (lower-right).
        // sin(30 deg) = 0.5, so the bottom of the arc extends 0.5 * radius below center.
        // Top of arc extends radius above center.
        // Total vertical span from top to bottom-dot = radius + 0.5 * radius = 1.5 * radius.
        // So: 1.5 * radius <= availableHeight -> radius <= availableHeight / 1.5
        // Also: 2 * radius <= availableWidth -> radius <= availableWidth / 2
        let dotOrbitRadius = min(availableWidth / 2, availableHeight / 1.5)

        // Center: horizontally centered, vertically positioned so top of arc has room.
        let center = CGPoint(x: size.width * 0.5, y: inset + dotOrbitRadius)

        // Arc spans from 150 deg (lower-left) clockwise to 390 deg (lower-right) = 240 deg sweep
        let startAngle: CGFloat = 150
        let arcSpan: CGFloat = 240

        // 1. Draw dots evenly along the arc
        if _dotCount > 1 {
            let resolvedDotColor = _dotColor ?? Color(red: 0.16, green: 0.16, blue: 0.15).opacity(0.35)
            let dotStep = arcSpan / CGFloat(_dotCount - 1)
            for i in 0..<_dotCount {
                let angleDeg = startAngle + CGFloat(i) * dotStep
                let rad = angleDeg * .pi / 180
                let dotCenter = CGPoint(
                    x: center.x + dotOrbitRadius * cos(rad),
                    y: center.y + dotOrbitRadius * sin(rad)
                )
                let dotPath = Path(ellipseIn: CGRect(
                    x: dotCenter.x - _dotRadius,
                    y: dotCenter.y - _dotRadius,
                    width: _dotRadius * 2,
                    height: _dotRadius * 2
                ))
                context.fill(dotPath, with: .color(resolvedDotColor))
            }
        }

        // 2. Draw arc segments just inside the dot orbit
        let arcRadius = dotOrbitRadius * 0.88
        let totalGap = _gapDegrees * CGFloat(max(_segments.count - 1, 0))
        let usableArc = arcSpan - totalGap
        var currentAngle = startAngle

        let style = StrokeStyle(lineWidth: _strokeWidth, lineCap: .round)

        for (index, segment) in _segments.enumerated() {
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
            if index < _segments.count - 1 {
                currentAngle += _gapDegrees
            }
        }
    }
}

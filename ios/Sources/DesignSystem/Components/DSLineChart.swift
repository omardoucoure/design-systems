import SwiftUI

// MARK: - DSLineChartData

/// A single data point for the line chart, with x and y values normalized to 0...1.
public struct DSLineChartPoint {
    /// Horizontal position (0 = left, 1 = right).
    public let x: CGFloat
    /// Vertical position (0 = bottom, 1 = top).
    public let y: CGFloat

    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

// MARK: - DSLineChart

/// A smooth line chart with a dampened shadow line.
///
/// The main line is drawn as a Catmull-Rom spline through the data points.
/// The shadow is a **compressed version** of the same curve — peaks are
/// pulled down and valleys are pulled up toward the midline. This creates
/// a natural depth effect where the shadow peeks out below peaks and above
/// valleys, matching the Figma "Line + Line Shadow" design pattern.
///
/// The shadow is also slightly blurred with `multiply` blend mode.
///
/// Usage:
/// ```swift
/// DSLineChart(
///     points: heartRatePoints,
///     lineColor: theme.colors.textNeutral9,
///     shadowColor: theme.brand.primitives.primary120
/// )
/// .frame(height: 80)
/// ```
public struct DSLineChart: View {
    @Environment(\.theme) private var theme

    private let points: [DSLineChartPoint]
    private let lineColor: Color?
    private let shadowColor: Color?
    private let lineWidth: CGFloat
    private let shadowBlur: CGFloat
    private let shadowOpacity: Double
    private let shadowDamping: CGFloat
    private let showShadow: Bool

    /// - Parameters:
    ///   - points: Data points normalized to 0...1 for both axes.
    ///   - lineColor: Stroke color for the line (defaults to textNeutral9).
    ///   - shadowColor: Stroke color for the shadow (defaults to surfacePrimary120).
    ///   - lineWidth: Stroke width (default 2).
    ///   - shadowBlur: Gaussian blur radius for the shadow (default 1.5).
    ///   - shadowOpacity: Opacity of the shadow line (default 0.2).
    ///   - shadowDamping: How much the shadow is compressed toward the midline (default 0.35).
    ///     0 = shadow matches main line exactly, 1 = shadow is a flat line.
    ///   - showShadow: Whether to show the shadow (default true).
    public init(
        points: [DSLineChartPoint],
        lineColor: Color? = nil,
        shadowColor: Color? = nil,
        lineWidth: CGFloat = 2,
        shadowBlur: CGFloat = 1.5,
        shadowOpacity: Double = 0.2,
        shadowDamping: CGFloat = 0.35,
        showShadow: Bool = true
    ) {
        self.points = points
        self.lineColor = lineColor
        self.shadowColor = shadowColor
        self.lineWidth = lineWidth
        self.shadowBlur = shadowBlur
        self.shadowOpacity = shadowOpacity
        self.shadowDamping = shadowDamping
        self.showShadow = showShadow
    }

    public var body: some View {
        Canvas { context, size in
            guard points.count >= 2 else { return }

            let strokeStyle = StrokeStyle(
                lineWidth: lineWidth, lineCap: .round, lineJoin: .round
            )

            // Shadow line — peaks compressed down, valleys unchanged
            if showShadow {
                let mid = midY
                let shadowPoints = points.map { pt -> DSLineChartPoint in
                    if pt.y > mid {
                        // Above midline (peak) — pull down toward mid
                        let dampedY = pt.y - (pt.y - mid) * shadowDamping
                        return DSLineChartPoint(x: pt.x, y: dampedY)
                    } else {
                        // At or below midline (valley) — keep same position
                        return pt
                    }
                }
                let shadowPath = smoothPath(for: shadowPoints, in: size)

                var shadowCtx = context
                shadowCtx.opacity = shadowOpacity
                shadowCtx.blendMode = .multiply
                shadowCtx.addFilter(.blur(radius: shadowBlur))

                shadowCtx.stroke(
                    shadowPath,
                    with: .color(shadowColor ?? theme.brand.primitives.primary120),
                    style: strokeStyle
                )
            }

            // Main line
            let mainPath = smoothPath(for: points, in: size)
            context.stroke(
                mainPath,
                with: .color(lineColor ?? theme.colors.textNeutral9),
                style: strokeStyle
            )
        }
    }

    /// Average y value of all points — used as the midline for shadow damping.
    private var midY: CGFloat {
        guard !points.isEmpty else { return 0.5 }
        return points.map(\.y).reduce(0, +) / CGFloat(points.count)
    }

    // MARK: - Smooth Path (Catmull-Rom → Cubic Bezier)

    private func smoothPath(for pts: [DSLineChartPoint], in size: CGSize) -> Path {
        let sorted = pts.sorted { $0.x < $1.x }
        let mapped = sorted.map { pt in
            CGPoint(x: pt.x * size.width, y: (1 - pt.y) * size.height)
        }

        var path = Path()
        guard mapped.count >= 2 else { return path }

        path.move(to: mapped[0])

        if mapped.count == 2 {
            path.addLine(to: mapped[1])
            return path
        }

        // Mirror endpoints to maintain tangent continuity at edges.
        // Without this, the first/last segments go flat.
        let first = mapped[0]
        let second = mapped[1]
        let mirror0 = CGPoint(x: 2 * first.x - second.x, y: 2 * first.y - second.y)

        let last = mapped[mapped.count - 1]
        let penult = mapped[mapped.count - 2]
        let mirrorN = CGPoint(x: 2 * last.x - penult.x, y: 2 * last.y - penult.y)

        let tension: CGFloat = 0.40

        for i in 0..<(mapped.count - 1) {
            let p0 = i > 0 ? mapped[i - 1] : mirror0
            let p1 = mapped[i]
            let p2 = mapped[i + 1]
            let p3 = i + 2 < mapped.count ? mapped[i + 2] : mirrorN

            let cp1 = CGPoint(
                x: p1.x + (p2.x - p0.x) * tension,
                y: p1.y + (p2.y - p0.y) * tension
            )
            let cp2 = CGPoint(
                x: p2.x - (p3.x - p1.x) * tension,
                y: p2.y - (p3.y - p1.y) * tension
            )

            path.addCurve(to: p2, control1: cp1, control2: cp2)
        }

        return path
    }
}

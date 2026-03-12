import SwiftUI

// MARK: - DSStatsChart Data

public struct DSStatsChartData: Identifiable {
    public let id = UUID()
    public let label: String
    public let value: CGFloat

    public init(label: String, value: CGFloat) {
        self.label = label
        self.value = value
    }
}

// MARK: - DSStatsChart Style

public enum DSStatsChartStyle: Sendable {
    /// Light background (surfaceNeutral2). Dark text, surfaceNeutral0_5 bars.
    case light
    /// Medium background (surfacePrimary100). Light text, surfaceNeutral9 bars at 20% opacity.
    case medium
    /// Dark background (surfacePrimary120). Light text, surfaceNeutral3 bars at 10% opacity.
    case dark
    /// Brand background (surfaceSecondary100). Dark text/line, surfaceNeutral9 bars at 6% opacity.
    case brand
}

// MARK: - DSStatsChart

/// A chart combining pill-shaped background bars, a smooth line overlay,
/// y-axis labels, month labels, and a floating badge.
///
/// Usage:
/// ```swift
/// DSStatsChart(
///     data: months,
///     linePoints: points,
///     style: .light,
///     badgeText: "$620",
///     badgePosition: (x: 0.6, y: 0.4)
/// )
/// ```
public struct DSStatsChart: View {
    @Environment(\.theme) private var theme
    @State private var lineProgress: CGFloat = 0

    private let data: [DSStatsChartData]
    private let linePoints: [DSLineChartPoint]
    private let style: DSStatsChartStyle
    private let yLabels: [String]
    private let badgeText: String?
    private let badgeX: CGFloat
    private let badgeY: CGFloat
    private let barHeight: CGFloat
    private let barWidth: CGFloat
    private let customLinePath: ((CGSize) -> Path)?
    private let customShadowPath: ((CGSize) -> Path)?
    private let useAutoLine: Bool

    /// Auto-line init — generates a smooth Catmull-Rom curve from data values.
    ///
    /// The line passes through one point per bar, centered on each bar.
    /// Y values are normalized from the data's min/max range.
    /// Shadow is automatically generated with a vertical offset.
    ///
    /// ```swift
    /// DSStatsChart(
    ///     data: months,        // values drive the curve shape
    ///     style: .brand,
    ///     badgeText: "$620",
    ///     badgeX: 0.75, badgeY: 0.42
    /// )
    /// ```
    public init(
        data: [DSStatsChartData],
        style: DSStatsChartStyle = .light,
        yLabels: [String] = ["6", "4", "2", "0"],
        badgeText: String? = nil,
        badgeX: CGFloat = 0.5,
        badgeY: CGFloat = 0.5,
        barHeight: CGFloat = 108,
        barWidth: CGFloat = 32
    ) {
        self.data = data
        self.linePoints = []
        self.style = style
        self.yLabels = yLabels
        self.badgeText = badgeText
        self.badgeX = badgeX
        self.badgeY = badgeY
        self.barHeight = barHeight
        self.barWidth = barWidth
        self.customLinePath = nil
        self.customShadowPath = nil
        self.useAutoLine = true
    }

    /// Manual line-points init — caller provides explicit normalized points.
    public init(
        data: [DSStatsChartData],
        linePoints: [DSLineChartPoint],
        style: DSStatsChartStyle = .light,
        yLabels: [String] = ["6", "4", "2", "0"],
        badgeText: String? = nil,
        badgeX: CGFloat = 0.5,
        badgeY: CGFloat = 0.5,
        barHeight: CGFloat = 108,
        barWidth: CGFloat = 32
    ) {
        self.data = data
        self.linePoints = linePoints
        self.style = style
        self.yLabels = yLabels
        self.badgeText = badgeText
        self.badgeX = badgeX
        self.badgeY = badgeY
        self.barHeight = barHeight
        self.barWidth = barWidth
        self.customLinePath = nil
        self.customShadowPath = nil
        self.useAutoLine = false
    }

    /// Custom SVG-derived paths init.
    public init(
        data: [DSStatsChartData],
        style: DSStatsChartStyle = .light,
        yLabels: [String] = ["6", "4", "2", "0"],
        badgeText: String? = nil,
        badgeX: CGFloat = 0.5,
        badgeY: CGFloat = 0.5,
        barHeight: CGFloat = 108,
        barWidth: CGFloat = 32,
        linePath: @escaping (CGSize) -> Path,
        shadowPath: ((CGSize) -> Path)? = nil
    ) {
        self.data = data
        self.linePoints = []
        self.style = style
        self.yLabels = yLabels
        self.badgeText = badgeText
        self.badgeX = badgeX
        self.badgeY = badgeY
        self.barHeight = barHeight
        self.barWidth = barWidth
        self.customLinePath = linePath
        self.customShadowPath = shadowPath
        self.useAutoLine = false
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            chartContent

            if let badgeText {
                badgeOverlay(badgeText)
                    .opacity(lineProgress)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                lineProgress = 1
            }
        }
    }

    // MARK: - Chart Content

    private var chartContent: some View {
        HStack(alignment: .top, spacing: 14) {
            // Y-axis labels
            VStack(spacing: 16) {
                ForEach(yLabels, id: \.self) { label in
                    Text(label)
                        .font(tinyFont)
                        .tracking(tinyTracking)
                        .foregroundStyle(axisLabelColor)
                }
            }
            .padding(.top, 2)

            // Bars + line overlay
            ZStack(alignment: .top) {
                barsRow
                lineOverlay
            }
        }
    }

    // MARK: - Bars

    private var barsRow: some View {
        HStack(spacing: 20) {
            ForEach(data) { item in
                VStack(spacing: 9) {
                    Capsule()
                        .fill(barFillColor)
                        .opacity(barOpacity)
                        .frame(width: barWidth, height: barHeight)

                    Text(item.label)
                        .font(tinyFont)
                        .tracking(tinyTracking)
                        .foregroundStyle(axisLabelColor)
                }
            }
        }
    }

    // MARK: - Line Overlay

    @ViewBuilder
    private var lineOverlay: some View {
        if let customLinePath {
            canvasLineOverlay(customLinePath)
        } else if useAutoLine {
            autoLineOverlay
        } else {
            pointBasedLineOverlay
        }
    }

    /// Legacy: caller provides explicit DSLineChartPoint array.
    private var pointBasedLineOverlay: some View {
        GeometryReader { geo in
            DSLineChart(
                points: linePoints,
                lineColor: lineColor,
                shadowColor: resolvedShadowStrokeColor,
                lineWidth: lineStrokeWidth,
                shadowBlur: shadowBlurRadius,
                shadowOpacity: shadowAlpha,
                shadowDamping: shadowDampingValue
            )
            .frame(height: barHeight * 0.6)
            .padding(.top, barHeight * 0.12)
        }
        .frame(height: barHeight)
    }

    /// Auto-line: generates a smooth Catmull-Rom curve from data values.
    private var autoLineOverlay: some View {
        GeometryReader { geo in
            let lineArea = CGSize(width: geo.size.width, height: barHeight * 0.6)
            let offsetY = barHeight * 0.12

            Canvas { context, size in
                guard data.count >= 2 else { return }

                let strokeStyle = StrokeStyle(lineWidth: lineStrokeWidth, lineCap: .round, lineJoin: .round)

                // Map data values to pixel points spanning full width
                let mainPoints = autoLinePoints(in: lineArea)
                // Shadow points: peaks are dampened proportionally (higher = more gap)
                let shadowPoints = autoLineShadowPoints(in: lineArea)

                let shadowPath = catmullRomPath(through: shadowPoints)
                    .trimmedPath(from: 0, to: lineProgress)
                var shadowCtx = context
                shadowCtx.opacity = shadowAlpha
                shadowCtx.blendMode = .multiply
                shadowCtx.addFilter(.blur(radius: shadowBlurRadius))
                shadowCtx.translateBy(x: 0, y: offsetY)
                shadowCtx.stroke(shadowPath, with: .color(resolvedShadowStrokeColor), style: strokeStyle)

                // Main line
                let mainPath = catmullRomPath(through: mainPoints)
                    .trimmedPath(from: 0, to: lineProgress)
                var mainCtx = context
                mainCtx.translateBy(x: 0, y: offsetY)
                mainCtx.stroke(mainPath, with: .color(lineColor), style: strokeStyle)
            }
        }
        .frame(height: barHeight)
    }

    /// Custom path overlay (SVG-derived or manual).
    private func canvasLineOverlay(_ pathBuilder: @escaping (CGSize) -> Path) -> some View {
        GeometryReader { geo in
            let lineArea = CGSize(width: geo.size.width, height: barHeight * 0.6)
            let offsetY = barHeight * 0.12

            Canvas { context, size in
                let strokeStyle = StrokeStyle(lineWidth: lineStrokeWidth, lineCap: .round, lineJoin: .round)

                // Shadow — offset slightly below the main line for depth
                let shadowFull = customShadowPath?(lineArea) ?? pathBuilder(lineArea)
                let shadowTrimmed = shadowFull.trimmedPath(from: 0, to: lineProgress)
                var shadowCtx = context
                shadowCtx.opacity = shadowAlpha
                shadowCtx.blendMode = .multiply
                shadowCtx.addFilter(.blur(radius: shadowBlurRadius))
                shadowCtx.translateBy(x: 0, y: offsetY + shadowVerticalOffset)
                shadowCtx.stroke(shadowTrimmed, with: .color(resolvedShadowStrokeColor), style: strokeStyle)

                // Main line
                let mainFull = pathBuilder(lineArea)
                let mainTrimmed = mainFull.trimmedPath(from: 0, to: lineProgress)
                var mainCtx = context
                mainCtx.translateBy(x: 0, y: offsetY)
                mainCtx.stroke(mainTrimmed, with: .color(lineColor), style: strokeStyle)
            }
        }
        .frame(height: barHeight)
    }

    // MARK: - Auto-Line Path Generation

    /// Maps data values to pixel coordinates spanning the full width.
    ///
    /// Points are evenly distributed from x=0 to x=width (edge to edge).
    /// Y is normalized from 0 to max value, using the full chart height.
    private func autoLinePoints(in size: CGSize) -> [CGPoint] {
        guard data.count >= 2 else { return [] }

        let values = data.map(\.value)
        let maxVal = values.max() ?? 1
        let ceiling = maxVal * 1.05

        let count = data.count
        let inset: CGFloat = lineStrokeWidth + 1 // keep stroke visible at edges
        let usableWidth = size.width - inset * 2
        return data.enumerated().map { index, item in
            // X: evenly spread with small inset so stroke isn't clipped
            let x = inset + usableWidth * CGFloat(index) / CGFloat(count - 1)
            // Y: normalized and inverted (0 = top, height = bottom)
            let normalized = ceiling > 0 ? item.value / ceiling : 0.5
            let y = size.height * (1 - normalized)
            return CGPoint(x: x, y: y)
        }
    }

    /// Shadow points: same X positions, but Y values are dampened proportionally.
    ///
    /// The shadow multiplies each normalized value by `shadowDampingRatio` (e.g. 0.65).
    /// At low values the gap is tiny; at peaks the shadow sits noticeably lower.
    /// Start and end points match exactly (same position as main line).
    private func autoLineShadowPoints(in size: CGSize) -> [CGPoint] {
        guard data.count >= 2 else { return [] }

        let values = data.map(\.value)
        let maxVal = values.max() ?? 1
        let ceiling = maxVal * 1.05

        let count = data.count
        let inset: CGFloat = lineStrokeWidth + 1
        let usableWidth = size.width - inset * 2
        let damping = shadowDampingRatio

        return data.enumerated().map { index, item in
            let x = inset + usableWidth * CGFloat(index) / CGFloat(count - 1)
            let normalized = ceiling > 0 ? item.value / ceiling : 0.5
            // Dampen: shadow value = normalized * ratio
            // This means at high values the shadow sits lower (bigger gap),
            // at low values it's nearly the same position
            let dampened = normalized * damping
            let y = size.height * (1 - dampened)
            return CGPoint(x: x, y: y)
        }
    }

    /// Catmull-Rom spline through pixel points — produces smooth wave curves.
    ///
    /// Uses mirrored ghost endpoints for tangent continuity at edges,
    /// and a tension of 0.35 for broad, gentle arcs (lower = rounder).
    private func catmullRomPath(through points: [CGPoint]) -> Path {
        var path = Path()
        guard points.count >= 2 else { return path }

        path.move(to: points[0])

        if points.count == 2 {
            path.addLine(to: points[1])
            return path
        }

        // Mirror endpoints to maintain tangent continuity at edges
        let first = points[0]
        let second = points[1]
        let mirror0 = CGPoint(x: 2 * first.x - second.x, y: 2 * first.y - second.y)

        let last = points[points.count - 1]
        let penult = points[points.count - 2]
        let mirrorN = CGPoint(x: 2 * last.x - penult.x, y: 2 * last.y - penult.y)

        // Lower tension = rounder, broader curves (0.25 is very smooth)
        let tension: CGFloat = 0.25

        for i in 0..<(points.count - 1) {
            let p0 = i > 0 ? points[i - 1] : mirror0
            let p1 = points[i]
            let p2 = points[i + 1]
            let p3 = i + 2 < points.count ? points[i + 2] : mirrorN

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

    // MARK: - Badge

    private func badgeOverlay(_ text: String) -> some View {
        GeometryReader { geo in
            Text(text)
                .font(.system(size: 10, weight: .semibold))
                .tracking(-0.2)
                .foregroundStyle(theme.colors.textNeutral9)
                .padding(.horizontal, theme.spacing.xs)
                .padding(.vertical, theme.spacing.xxs)
                .background(theme.colors.infoFocus)
                .clipShape(Capsule())
                .position(
                    x: geo.size.width * badgeX,
                    y: geo.size.height * badgeY
                )
        }
        .frame(height: barHeight + 24)
    }

    // MARK: - Style-Resolved Colors

    private var barFillColor: Color {
        switch style {
        case .light: return theme.colors.surfaceNeutral0_5
        case .medium, .brand: return theme.colors.surfaceNeutral9
        case .dark: return theme.colors.surfaceNeutral3
        }
    }

    private var barOpacity: Double {
        switch style {
        case .light: return 1.0
        case .medium: return 0.2
        case .dark: return 0.1
        case .brand: return 0.06
        }
    }

    private var axisLabelColor: Color {
        switch style {
        case .light, .brand: return theme.colors.textNeutral8
        case .medium, .dark: return theme.colors.textNeutral3
        }
    }

    private var lineColor: Color {
        switch style {
        case .light, .brand: return theme.colors.textNeutral9
        case .medium: return theme.colors.surfaceSecondary100
        case .dark: return theme.colors.surfaceSecondary100
        }
    }

    private var shadowColor: Color {
        switch style {
        case .light, .brand: return theme.colors.textNeutral9.opacity(0.3)
        case .medium: return theme.colors.surfaceSecondary100.opacity(0.3)
        case .dark: return theme.colors.surfaceSecondary100.opacity(0.3)
        }
    }

    // MARK: - Line & Shadow Parameters

    private var lineStrokeWidth: CGFloat {
        switch style {
        case .brand: return 3
        default: return 2
        }
    }

    private var resolvedShadowStrokeColor: Color {
        switch style {
        case .brand: return theme.colors.surfacePrimary120
        default: return shadowColor
        }
    }

    private var shadowBlurRadius: CGFloat {
        switch style {
        case .brand: return 3
        default: return 2
        }
    }

    private var shadowAlpha: Double {
        switch style {
        case .brand: return 0.35
        default: return 0.3
        }
    }

    private var shadowDampingValue: CGFloat {
        switch style {
        case .brand: return 0.55
        default: return 0.35
        }
    }

    private var shadowVerticalOffset: CGFloat {
        switch style {
        case .brand: return 6
        default: return 3
        }
    }

    /// How much the shadow follows the main line's peaks.
    /// 1.0 = identical to main line, 0.5 = shadow only goes halfway up.
    /// At valleys (low values), the gap is small; at peaks, the gap is large.
    private var shadowDampingRatio: CGFloat {
        switch style {
        case .brand: return 0.65
        default: return 0.70
        }
    }

    // MARK: - Typography

    private var tinyFont: Font {
        .system(size: 10, weight: .medium)
    }

    private var tinyTracking: CGFloat {
        -0.2
    }
}

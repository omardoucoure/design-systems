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
    /// Light background (surfaceNeutral2). Dark text, surfaceNeutral05 bars.
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
/// Usage (modifier API):
/// ```swift
/// // Auto-line (default) — curve generated from data values
/// DSStatsChart(data: months)
///     .chartStyle(.brand)
///     .badgeText("$620")
///     .badgePosition(x: 0.75, y: 0.42)
///
/// // Manual line points
/// DSStatsChart(data: months)
///     .linePoints(savingsLinePoints)
///     .chartStyle(.light)
///     .badgeText("$620")
///     .badgePosition(x: 0.58, y: 0.72)
///
/// // Custom SVG-derived paths
/// DSStatsChart(data: months)
///     .linePath { size in myPath(size) }
///     .shadowPath { size in myShadow(size) }
/// ```
public struct DSStatsChart: View {
    @Environment(\.theme) private var theme
    @State private var lineProgress: CGFloat = 0

    private let data: [DSStatsChartData]
    var _linePoints: [DSLineChartPoint] = []
    var _style: DSStatsChartStyle = .light
    var _yLabels: [String] = ["6", "4", "2", "0"]
    var _badgeText: String?
    var _badgeX: CGFloat = 0.5
    var _badgeY: CGFloat = 0.5
    var _barHeight: CGFloat = 108
    var _barWidth: CGFloat = 32
    var _customLinePath: ((CGSize) -> Path)?
    var _customShadowPath: ((CGSize) -> Path)?
    var _useAutoLine: Bool = true

    // MARK: - New Minimal Init

    public init(data: [DSStatsChartData]) {
        self.data = data
    }

    // MARK: - Deprecated Inits

    /// Auto-line init (deprecated).
    @available(*, deprecated, message: "Use DSStatsChart(data:) with modifier methods instead")
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
        self._style = style
        self._yLabels = yLabels
        self._badgeText = badgeText
        self._badgeX = badgeX
        self._badgeY = badgeY
        self._barHeight = barHeight
        self._barWidth = barWidth
        self._useAutoLine = true
    }

    /// Manual line-points init (deprecated).
    @available(*, deprecated, message: "Use DSStatsChart(data:) with .linePoints() modifier instead")
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
        self._linePoints = linePoints
        self._style = style
        self._yLabels = yLabels
        self._badgeText = badgeText
        self._badgeX = badgeX
        self._badgeY = badgeY
        self._barHeight = barHeight
        self._barWidth = barWidth
        self._useAutoLine = false
    }

    /// Custom SVG-derived paths init (deprecated).
    @available(*, deprecated, message: "Use DSStatsChart(data:) with .linePath() modifier instead")
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
        self._style = style
        self._yLabels = yLabels
        self._badgeText = badgeText
        self._badgeX = badgeX
        self._badgeY = badgeY
        self._barHeight = barHeight
        self._barWidth = barWidth
        self._customLinePath = linePath
        self._customShadowPath = shadowPath
        self._useAutoLine = false
    }

    // MARK: - Modifiers

    public func chartStyle(_ style: DSStatsChartStyle) -> DSStatsChart {
        var copy = self; copy._style = style; return copy
    }

    public func linePoints(_ points: [DSLineChartPoint]) -> DSStatsChart {
        var copy = self; copy._linePoints = points; copy._useAutoLine = false; return copy
    }

    public func yLabels(_ labels: [String]) -> DSStatsChart {
        var copy = self; copy._yLabels = labels; return copy
    }

    public func badgeText(_ text: String?) -> DSStatsChart {
        var copy = self; copy._badgeText = text; return copy
    }

    public func badgePosition(x: CGFloat, y: CGFloat) -> DSStatsChart {
        var copy = self; copy._badgeX = x; copy._badgeY = y; return copy
    }

    public func barHeight(_ height: CGFloat) -> DSStatsChart {
        var copy = self; copy._barHeight = height; return copy
    }

    public func barWidth(_ width: CGFloat) -> DSStatsChart {
        var copy = self; copy._barWidth = width; return copy
    }

    public func linePath(_ builder: @escaping (CGSize) -> Path) -> DSStatsChart {
        var copy = self; copy._customLinePath = builder; copy._useAutoLine = false; return copy
    }

    public func shadowPath(_ builder: @escaping (CGSize) -> Path) -> DSStatsChart {
        var copy = self; copy._customShadowPath = builder; return copy
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .topLeading) {
            chartContent

            if let badgeText = _badgeText {
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
                ForEach(_yLabels, id: \.self) { label in
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
                        .frame(width: _barWidth, height: _barHeight)

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
        if let customLinePath = _customLinePath {
            canvasLineOverlay(customLinePath)
        } else if _useAutoLine {
            autoLineOverlay
        } else {
            pointBasedLineOverlay
        }
    }

    /// Legacy: caller provides explicit DSLineChartPoint array.
    private var pointBasedLineOverlay: some View {
        GeometryReader { geo in
            DSLineChart(points: _linePoints)
                .lineColor(lineColor)
                .shadowColor(resolvedShadowStrokeColor)
                .lineWidth(lineStrokeWidth)
                .shadowBlur(shadowBlurRadius)
                .shadowOpacity(shadowAlpha)
                .shadowDamping(shadowDampingValue)
                .frame(height: _barHeight * 0.6)
                .padding(.top, _barHeight * 0.12)
        }
        .frame(height: _barHeight)
    }

    /// Auto-line: generates a smooth Catmull-Rom curve from data values.
    private var autoLineOverlay: some View {
        GeometryReader { geo in
            let lineArea = CGSize(width: geo.size.width, height: _barHeight * 0.6)
            let offsetY = _barHeight * 0.12

            Canvas { context, size in
                guard data.count >= 2 else { return }

                let strokeStyle = StrokeStyle(lineWidth: lineStrokeWidth, lineCap: .round, lineJoin: .round)

                let mainPoints = autoLinePoints(in: lineArea)
                let shadowPoints = autoLineShadowPoints(in: lineArea)

                let shadowPath = catmullRomPath(through: shadowPoints)
                    .trimmedPath(from: 0, to: lineProgress)
                var shadowCtx = context
                shadowCtx.opacity = shadowAlpha
                shadowCtx.blendMode = .multiply
                shadowCtx.addFilter(.blur(radius: shadowBlurRadius))
                shadowCtx.translateBy(x: 0, y: offsetY)
                shadowCtx.stroke(shadowPath, with: .color(resolvedShadowStrokeColor), style: strokeStyle)

                let mainPath = catmullRomPath(through: mainPoints)
                    .trimmedPath(from: 0, to: lineProgress)
                var mainCtx = context
                mainCtx.translateBy(x: 0, y: offsetY)
                mainCtx.stroke(mainPath, with: .color(lineColor), style: strokeStyle)
            }
        }
        .frame(height: _barHeight)
    }

    /// Custom path overlay (SVG-derived or manual).
    private func canvasLineOverlay(_ pathBuilder: @escaping (CGSize) -> Path) -> some View {
        GeometryReader { geo in
            let lineArea = CGSize(width: geo.size.width, height: _barHeight * 0.6)
            let offsetY = _barHeight * 0.12

            Canvas { context, size in
                let strokeStyle = StrokeStyle(lineWidth: lineStrokeWidth, lineCap: .round, lineJoin: .round)

                let shadowFull = _customShadowPath?(lineArea) ?? pathBuilder(lineArea)
                let shadowTrimmed = shadowFull.trimmedPath(from: 0, to: lineProgress)
                var shadowCtx = context
                shadowCtx.opacity = shadowAlpha
                shadowCtx.blendMode = .multiply
                shadowCtx.addFilter(.blur(radius: shadowBlurRadius))
                shadowCtx.translateBy(x: 0, y: offsetY + shadowVerticalOffset)
                shadowCtx.stroke(shadowTrimmed, with: .color(resolvedShadowStrokeColor), style: strokeStyle)

                let mainFull = pathBuilder(lineArea)
                let mainTrimmed = mainFull.trimmedPath(from: 0, to: lineProgress)
                var mainCtx = context
                mainCtx.translateBy(x: 0, y: offsetY)
                mainCtx.stroke(mainTrimmed, with: .color(lineColor), style: strokeStyle)
            }
        }
        .frame(height: _barHeight)
    }

    // MARK: - Auto-Line Path Generation

    private func autoLinePoints(in size: CGSize) -> [CGPoint] {
        guard data.count >= 2 else { return [] }

        let values = data.map(\.value)
        let maxVal = values.max() ?? 1
        let ceiling = maxVal * 1.05

        let count = data.count
        let inset: CGFloat = lineStrokeWidth + 1
        let usableWidth = size.width - inset * 2
        return data.enumerated().map { index, item in
            let x = inset + usableWidth * CGFloat(index) / CGFloat(count - 1)
            let normalized = ceiling > 0 ? item.value / ceiling : 0.5
            let y = size.height * (1 - normalized)
            return CGPoint(x: x, y: y)
        }
    }

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
            let dampened = normalized * damping
            let y = size.height * (1 - dampened)
            return CGPoint(x: x, y: y)
        }
    }

    private func catmullRomPath(through points: [CGPoint]) -> Path {
        var path = Path()
        guard points.count >= 2 else { return path }

        path.move(to: points[0])

        if points.count == 2 {
            path.addLine(to: points[1])
            return path
        }

        let first = points[0]
        let second = points[1]
        let mirror0 = CGPoint(x: 2 * first.x - second.x, y: 2 * first.y - second.y)

        let last = points[points.count - 1]
        let penult = points[points.count - 2]
        let mirrorN = CGPoint(x: 2 * last.x - penult.x, y: 2 * last.y - penult.y)

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
                    x: geo.size.width * _badgeX,
                    y: geo.size.height * _badgeY
                )
        }
        .frame(height: _barHeight + 24)
    }

    // MARK: - Style-Resolved Colors

    private var barFillColor: Color {
        switch _style {
        case .light: return theme.colors.surfaceNeutral05
        case .medium, .brand: return theme.colors.surfaceNeutral9
        case .dark: return theme.colors.surfaceNeutral3
        }
    }

    private var barOpacity: Double {
        switch _style {
        case .light: return 1.0
        case .medium: return 0.2
        case .dark: return 0.1
        case .brand: return 0.06
        }
    }

    private var axisLabelColor: Color {
        switch _style {
        case .light, .brand: return theme.colors.textNeutral8
        case .medium, .dark: return theme.colors.textNeutral3
        }
    }

    private var lineColor: Color {
        switch _style {
        case .light, .brand: return theme.colors.textNeutral9
        case .medium: return theme.colors.surfaceSecondary100
        case .dark: return theme.colors.surfaceSecondary100
        }
    }

    private var shadowColor: Color {
        switch _style {
        case .light, .brand: return theme.colors.textNeutral9.opacity(0.3)
        case .medium: return theme.colors.surfaceSecondary100.opacity(0.3)
        case .dark: return theme.colors.surfaceSecondary100.opacity(0.3)
        }
    }

    // MARK: - Line & Shadow Parameters

    private var lineStrokeWidth: CGFloat {
        switch _style {
        case .brand: return 3
        default: return 2
        }
    }

    private var resolvedShadowStrokeColor: Color {
        switch _style {
        case .brand: return theme.colors.surfacePrimary120
        default: return shadowColor
        }
    }

    private var shadowBlurRadius: CGFloat {
        switch _style {
        case .brand: return 3
        default: return 2
        }
    }

    private var shadowAlpha: Double {
        switch _style {
        case .brand: return 0.35
        default: return 0.3
        }
    }

    private var shadowDampingValue: CGFloat {
        switch _style {
        case .brand: return 0.55
        default: return 0.35
        }
    }

    private var shadowVerticalOffset: CGFloat {
        switch _style {
        case .brand: return 6
        default: return 3
        }
    }

    private var shadowDampingRatio: CGFloat {
        switch _style {
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

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

    private let data: [DSStatsChartData]
    private let linePoints: [DSLineChartPoint]
    private let style: DSStatsChartStyle
    private let yLabels: [String]
    private let badgeText: String?
    private let badgeX: CGFloat
    private let badgeY: CGFloat
    private let barHeight: CGFloat
    private let barWidth: CGFloat

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
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            chartContent

            if let badgeText {
                badgeOverlay(badgeText)
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

    private var lineOverlay: some View {
        GeometryReader { geo in
            DSLineChart(
                points: linePoints,
                lineColor: lineColor,
                shadowColor: shadowColor,
                lineWidth: 2,
                shadowBlur: 2,
                shadowOpacity: 0.3,
                shadowDamping: 0.35
            )
            .frame(height: barHeight * 0.6)
            .padding(.top, barHeight * 0.12)
        }
        .frame(height: barHeight)
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
        case .medium: return theme.colors.surfaceNeutral9
        case .dark: return theme.colors.surfaceNeutral3
        }
    }

    private var barOpacity: Double {
        switch style {
        case .light: return 1.0
        case .medium: return 0.2
        case .dark: return 0.1
        }
    }

    private var axisLabelColor: Color {
        switch style {
        case .light: return theme.colors.textNeutral8
        case .medium, .dark: return theme.colors.textNeutral3
        }
    }

    private var lineColor: Color {
        switch style {
        case .light: return theme.colors.textNeutral9
        case .medium: return theme.colors.surfaceSecondary100
        case .dark: return theme.colors.surfaceSecondary100
        }
    }

    private var shadowColor: Color {
        switch style {
        case .light: return theme.colors.textNeutral9.opacity(0.3)
        case .medium: return theme.colors.surfaceSecondary100.opacity(0.3)
        case .dark: return theme.colors.surfaceSecondary100.opacity(0.3)
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

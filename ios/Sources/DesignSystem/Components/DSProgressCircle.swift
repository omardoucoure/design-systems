import SwiftUI

// MARK: - DSProgressCircle

/// A themed circular progress indicator with percentage label.
///
/// Two-ring design: a very thin full-circle track beneath a thicker rounded-cap
/// progress arc drawn on top — matching the Figma design exactly.
///
/// Usage:
/// ```swift
/// DSProgressCircle(progress: 0.75)
/// DSProgressCircle(progress: 0.5, size: 56)
/// ```
public struct DSProgressCircle: View {
    @Environment(\.theme) private var theme

    private let progress: Double
    private let size: CGFloat
    /// Stroke width for the thick progress arc.
    private let lineWidth: CGFloat
    /// Stroke width for the thin background track. Defaults to 1.
    private let trackLineWidth: CGFloat?

    private let customLabel: String?
    private let trackColor: Color?
    private let progressColor: Color?
    private let labelColor: Color?

    /// - Parameters:
    ///   - progress: Value between 0.0 and 1.0.
    ///   - size: Diameter of the circle (default 40).
    ///   - lineWidth: Stroke width for the thick progress arc (default 6).
    ///   - trackLineWidth: Stroke width for the thin background ring (default 1).
    ///   - customLabel: Override center text (defaults to percentage string).
    ///   - trackColor: Override track ring color.
    ///   - progressColor: Override arc color.
    ///   - labelColor: Override label color.
    public init(
        progress: Double,
        size: CGFloat = 40,
        lineWidth: CGFloat = 8.6,
        trackLineWidth: CGFloat? = nil,
        customLabel: String? = nil,
        trackColor: Color? = nil,
        progressColor: Color? = nil,
        labelColor: Color? = nil
    ) {
        self.progress = min(max(progress, 0), 1)
        self.size = size
        self.lineWidth = lineWidth
        self.trackLineWidth = trackLineWidth
        self.customLabel = customLabel
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.labelColor = labelColor
    }

    /// Resolved track stroke width — very thin by default (1pt).
    private var resolvedTrackLineWidth: CGFloat {
        trackLineWidth ?? 1
    }

    public var body: some View {
        ZStack {
            // Track — very thin full ring, centered on the same radius as the arc.
            // Inset by lineWidth/2 so both rings share the same center-path radius.
            Circle()
                .stroke(
                    trackColor ?? theme.colors.surfaceNeutral3,
                    lineWidth: resolvedTrackLineWidth
                )
                .padding(lineWidth / 2)

            // Progress arc — thick with rounded caps, on top of the track.
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progressColor ?? theme.colors.surfaceSecondary100,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .padding(lineWidth / 2)

            // Center label
            Text(customLabel ?? "\(Int(progress * 100))")
                .font(theme.typography.smallSemiBold.font)
                .tracking(theme.typography.smallSemiBold.tracking)
                .foregroundStyle(
                    labelColor ?? theme.colors.textNeutral9
                        .opacity(theme.colors.textOpacity75)
                )
        }
        .frame(width: size, height: size)
    }
}

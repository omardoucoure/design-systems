import SwiftUI

// MARK: - DSProgressCircle

/// A themed circular progress indicator with percentage label.
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
    /// Stroke width for the progress arc.
    private let lineWidth: CGFloat
    /// Stroke width for the track ring. Defaults to ~25% of lineWidth for a thin/bold contrast.
    private let trackLineWidth: CGFloat?

    private let customLabel: String?
    private let trackColor: Color?
    private let progressColor: Color?
    private let labelColor: Color?

    /// - Parameters:
    ///   - progress: Value between 0.0 and 1.0.
    ///   - size: Diameter of the circle (default 40).
    ///   - lineWidth: Stroke width for the progress arc (default 6).
    ///   - trackLineWidth: Stroke width for the background track ring. Defaults to ~25% of lineWidth.
    ///   - customLabel: Override center text (defaults to percentage string).
    ///   - trackColor: Override track ring color (defaults to surfaceNeutral1).
    ///   - progressColor: Override arc color (defaults to surfaceSecondary100).
    ///   - labelColor: Override label color (defaults to textNeutral9 at 75%).
    public init(
        progress: Double,
        size: CGFloat = 40,
        lineWidth: CGFloat = 4,
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

    /// Resolved track stroke width: explicit value, or same as arc lineWidth (full visible ring).
    private var resolvedTrackLineWidth: CGFloat {
        trackLineWidth ?? lineWidth
    }

    public var body: some View {
        ZStack {
            // Track — thin background ring, inset so both rings share the same path radius
            Circle()
                .stroke(
                    trackColor ?? theme.colors.surfaceNeutral3,
                    lineWidth: resolvedTrackLineWidth
                )
                .padding(lineWidth / 2)

            // Progress arc — bold with rounded caps, same inset as track
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

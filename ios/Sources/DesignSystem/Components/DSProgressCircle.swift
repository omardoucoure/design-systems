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
/// DSProgressCircle(progress: 0.5)
///     .circleSize(56)
///     .progressColor(theme.colors.surfaceSecondary100)
/// ```
public struct DSProgressCircle: View {
    @Environment(\.theme) private var theme

    private let progress: Double
    private var _circleSize: CGFloat = 40
    /// Stroke width for the thick progress arc.
    private var _lineWidth: CGFloat = 8.6
    /// Stroke width for the thin background track. Defaults to 1.
    private var _trackLineWidth: CGFloat?

    private var _customLabel: String?
    private var _trackColor: Color?
    private var _progressColor: Color?
    private var _labelColor: Color?

    // MARK: - Init

    /// - Parameter progress: Value between 0.0 and 1.0.
    public init(progress: Double) {
        self.progress = min(max(progress, 0), 1)
    }

    /// Deprecated — use the modifier-based API instead.
    @available(*, deprecated, message: "Use DSProgressCircle(progress:) with .circleSize(), .lineWidth(), .trackLineWidth(), .customLabel(), .trackColor(), .progressColor(), .labelColor() modifiers")
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
        self._circleSize = size
        self._lineWidth = lineWidth
        self._trackLineWidth = trackLineWidth
        self._customLabel = customLabel
        self._trackColor = trackColor
        self._progressColor = progressColor
        self._labelColor = labelColor
    }

    // MARK: - Modifiers

    public func circleSize(_ size: CGFloat) -> Self {
        var copy = self
        copy._circleSize = size
        return copy
    }

    public func lineWidth(_ width: CGFloat) -> Self {
        var copy = self
        copy._lineWidth = width
        return copy
    }

    public func trackLineWidth(_ width: CGFloat) -> Self {
        var copy = self
        copy._trackLineWidth = width
        return copy
    }

    public func customLabel(_ label: String) -> Self {
        var copy = self
        copy._customLabel = label
        return copy
    }

    public func trackColor(_ color: Color) -> Self {
        var copy = self
        copy._trackColor = color
        return copy
    }

    public func progressColor(_ color: Color) -> Self {
        var copy = self
        copy._progressColor = color
        return copy
    }

    public func labelColor(_ color: Color) -> Self {
        var copy = self
        copy._labelColor = color
        return copy
    }

    // MARK: - Body

    /// Resolved track stroke width — very thin by default (1pt).
    private var resolvedTrackLineWidth: CGFloat {
        _trackLineWidth ?? 1
    }

    public var body: some View {
        ZStack {
            // Track — very thin full ring, centered on the same radius as the arc.
            // Inset by lineWidth/2 so both rings share the same center-path radius.
            Circle()
                .stroke(
                    _trackColor ?? theme.colors.surfaceNeutral3,
                    lineWidth: resolvedTrackLineWidth
                )
                .padding(_lineWidth / 2)

            // Progress arc — thick with rounded caps, on top of the track.
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    _progressColor ?? theme.colors.surfaceSecondary100,
                    style: StrokeStyle(lineWidth: _lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .padding(_lineWidth / 2)

            // Center label
            Text(_customLabel ?? "\(Int(progress * 100))")
                .font(theme.typography.smallSemiBold.font)
                .tracking(theme.typography.smallSemiBold.tracking)
                .foregroundStyle(
                    _labelColor ?? theme.colors.textNeutral9
                        .opacity(theme.colors.textOpacity75)
                )
        }
        .frame(width: _circleSize, height: _circleSize)
    }
}

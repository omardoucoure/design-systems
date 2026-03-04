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
    private let lineWidth: CGFloat

    /// - Parameters:
    ///   - progress: Value between 0.0 and 1.0.
    ///   - size: Diameter of the circle (default 40).
    ///   - lineWidth: Stroke width (default 3).
    public init(progress: Double, size: CGFloat = 40, lineWidth: CGFloat = 3) {
        self.progress = min(max(progress, 0), 1)
        self.size = size
        self.lineWidth = lineWidth
    }

    public var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(
                    theme.colors.surfaceNeutral3,
                    lineWidth: lineWidth
                )

            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    theme.colors.surfacePrimary100,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            // Percentage label
            Text("\(Int(progress * 100))")
                .font(theme.typography.small.font)
                .tracking(theme.typography.small.tracking)
                .foregroundStyle(
                    theme.colors.textNeutral9
                        .opacity(theme.colors.textOpacity75)
                )
        }
        .frame(width: size, height: size)
    }
}

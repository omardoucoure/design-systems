import SwiftUI

/// A themed linear progress bar with a rounded track and fill.
///
/// Usage:
/// ```swift
/// DSProgressBar(progress: 0.4)
/// DSProgressBar(progress: 0.4)
///     .barHeight(6)
///     .fillColor(theme.colors.surfaceSecondary100)
/// ```
public struct DSProgressBar: View {
    @Environment(\.theme) private var theme

    private let progress: Double
    private var _barHeight: CGFloat = 6
    private var _trackColor: Color?
    private var _fillColor: Color?

    /// - Parameter progress: Value between 0.0 and 1.0.
    public init(progress: Double) {
        self.progress = min(max(progress, 0), 1)
    }

    public func barHeight(_ height: CGFloat) -> Self {
        var copy = self
        copy._barHeight = height
        return copy
    }

    public func trackColor(_ color: Color) -> Self {
        var copy = self
        copy._trackColor = color
        return copy
    }

    public func fillColor(_ color: Color) -> Self {
        var copy = self
        copy._fillColor = color
        return copy
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(_trackColor ?? theme.colors.surfaceNeutral3)
                Capsule()
                    .fill(_fillColor ?? theme.colors.surfacePrimary100)
                    .frame(width: progress * geo.size.width)
            }
        }
        .frame(height: _barHeight)
    }
}

// figma-node: 87:100817
import SwiftUI

public struct DSTickScale: View {
    @Environment(\.theme) private var theme

    private let _sideCount: Int

    public init(sideCount: Int = 9) {
        self._sideCount = sideCount
    }

    private var metrics: TickScaleComponentTokens { theme.components.tickScale }

    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(0..<_sideCount, id: \.self) { index in
                tick(height: rampHeight(at: index))
                Spacer(minLength: 0)
            }

            tick(height: metrics.centerHeight, color: theme.colors.surfaceSecondary100)

            ForEach(0..<_sideCount, id: \.self) { index in
                Spacer(minLength: 0)
                tick(height: rampHeight(at: _sideCount - 1 - index))
            }
        }
        .frame(height: metrics.centerHeight)
    }

    private func rampHeight(at index: Int) -> CGFloat {
        metrics.minHeight + CGFloat(index) * metrics.step
    }

    private func tick(height: CGFloat, color: Color? = nil) -> some View {
        Capsule()
            .fill(color ?? theme.colors.borderNeutral95)
            .frame(width: metrics.tickWidth, height: height)
    }
}

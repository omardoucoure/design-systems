// figma-node: 87:100203
import SwiftUI

public struct DSStepper: View {
    @Environment(\.theme) private var theme

    @Binding private var value: Int
    private let range: ClosedRange<Int>

    public init(value: Binding<Int>, in range: ClosedRange<Int> = 1...99) {
        self._value = value
        self.range = range
    }

    public var body: some View {
        HStack(spacing: 0) {
            stepButton(icon: .minus, enabled: value > range.lowerBound) {
                value = max(range.lowerBound, value - 1)
            }

            Text("\(value)")
                .font(theme.typography.bodySemiBold.font)
                .tracking(theme.typography.bodySemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(minWidth: theme.spacing.xl)

            stepButton(icon: .plus, enabled: value < range.upperBound) {
                value = min(range.upperBound, value + 1)
            }
        }
        .padding(theme.spacing.xxs)
        .frame(height: 40)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(Capsule())
    }

    private func stepButton(icon: DSIcon, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(dsIcon: icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: theme.spacing.md, height: theme.spacing.md)
                .foregroundStyle(enabled ? theme.colors.textNeutral9 : theme.colors.textNeutral3)
                .frame(width: theme.spacing.xl, height: theme.spacing.xl)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}

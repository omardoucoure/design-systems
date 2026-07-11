// figma-node: 87:100203
import SwiftUI

public struct DSCheckoutStep: Identifiable {
    public let id: Int
    public let label: LocalizedStringKey
    public let icon: DSIcon

    public init(id: Int, label: LocalizedStringKey, icon: DSIcon) {
        self.id = id
        self.label = label
        self.icon = icon
    }
}

public struct DSCheckoutStepper: View {
    @Environment(\.theme) private var theme

    private let steps: [DSCheckoutStep]
    private let currentIndex: Int

    public init(steps: [DSCheckoutStep], currentIndex: Int) {
        self.steps = steps
        self.currentIndex = currentIndex
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                stepColumn(step, isActive: index == currentIndex)
                    .frame(maxWidth: .infinity)
            }
        }
        .background(alignment: .top) { connectorLine }
        .padding(.horizontal, theme.spacing.xs)
    }

    private func stepColumn(_ step: DSCheckoutStep, isActive: Bool) -> some View {
        VStack(spacing: theme.spacing.xxs) {
            Image(dsIcon: step.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: theme.spacing.lg, height: theme.spacing.lg)
                .foregroundStyle(theme.colors.textNeutral05)
                .padding(.horizontal, theme.spacing.sm)
                .padding(.vertical, theme.spacing.xxs)
                .frame(height: theme.spacing.xl)
                .background(isActive ? theme.colors.surfacePrimary120 : theme.colors.surfacePrimary100)
                .clipShape(Capsule())

            Text(step.label)
                .font(theme.typography.smallSemiBold.font)
                .tracking(theme.typography.smallSemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
        }
    }

    private var connectorLine: some View {
        Rectangle()
            .fill(theme.colors.borderNeutral05)
            .frame(height: 1)
            .padding(.horizontal, theme.spacing.xl)
            .padding(.top, theme.spacing.md)
    }
}

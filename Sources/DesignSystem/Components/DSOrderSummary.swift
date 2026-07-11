// figma-node: 87:100098
import SwiftUI

public struct DSOrderLine: Identifiable {
    public let id = UUID()
    public let label: LocalizedStringKey
    public let value: LocalizedStringKey

    public init(label: LocalizedStringKey, value: LocalizedStringKey) {
        self.label = label
        self.value = value
    }
}

public struct DSOrderSummary: View {
    @Environment(\.theme) private var theme

    private let lines: [DSOrderLine]
    private let totalLabel: LocalizedStringKey
    private let totalValue: LocalizedStringKey

    public init(lines: [DSOrderLine], totalLabel: LocalizedStringKey, totalValue: LocalizedStringKey) {
        self.lines = lines
        self.totalLabel = totalLabel
        self.totalValue = totalValue
    }

    public var body: some View {
        VStack(spacing: theme.spacing.xs) {
            ForEach(lines) { line in
                row(label: line.label, value: line.value,
                    font: theme.typography.small, color: theme.colors.textNeutral8)
            }

            grandRow
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
    }

    private var grandRow: some View {
        VStack(spacing: 0) {
            DSDivider()
                .dividerStyle(.fullBleed)
                .dividerColor(theme.colors.borderNeutral2)
                .padding(.bottom, theme.spacing.xs)

            row(label: totalLabel, value: totalValue,
                font: theme.typography.h6, color: theme.colors.textNeutral9)
        }
    }

    private func row(label: LocalizedStringKey, value: LocalizedStringKey,
                     font: TypographyStyle, color: Color) -> some View {
        HStack {
            Text(label)
                .font(font.font)
                .tracking(font.tracking)
                .foregroundStyle(color)
            Spacer(minLength: theme.spacing.md)
            Text(value)
                .font(font.font)
                .tracking(font.tracking)
                .foregroundStyle(color)
        }
    }
}

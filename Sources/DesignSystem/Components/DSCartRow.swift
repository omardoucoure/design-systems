// figma-node: 87:100080
import SwiftUI

public struct DSCartRow<Media: View>: View {
    @Environment(\.theme) private var theme

    private let title: LocalizedStringKey
    private let meta: LocalizedStringKey
    private let price: LocalizedStringKey
    @Binding private var quantity: Int
    private let media: Media

    public init(
        title: LocalizedStringKey,
        meta: LocalizedStringKey,
        price: LocalizedStringKey,
        quantity: Binding<Int>,
        @ViewBuilder media: () -> Media
    ) {
        self.title = title
        self.meta = meta
        self.price = price
        self._quantity = quantity
        self.media = media()
    }

    public var body: some View {
        HStack(spacing: theme.spacing.sm) {
            media
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))

            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(title)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
                    .lineLimit(1)
                Text(meta)
                    .font(theme.typography.small.font)
                    .tracking(theme.typography.small.tracking)
                    .foregroundStyle(theme.colors.textNeutral8)
            }

            Spacer(minLength: theme.spacing.xs)

            DSStepper(value: $quantity)

            Text(price)
                .font(theme.typography.bodySemiBold.font)
                .tracking(theme.typography.bodySemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
        }
        .padding(theme.spacing.sm)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
    }
}

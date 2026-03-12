import SwiftUI

// MARK: - DSProductCard

/// A product card with a photo, brand name, subtitle, price,
/// optional original price with strikethrough, and optional discount badge.
///
/// Figma: "1" / "2" product items inside "Teaser" rows.
///
/// Usage:
/// ```swift
/// DSProductCard(
///     image: "shop_product1",
///     brand: "Roa® Synthetic",
///     subtitle: "Hooded Down Jacket",
///     price: "$585",
///     originalPrice: "$590",
///     discount: "10%"
/// )
/// ```
public struct DSProductCard: View {
    @Environment(\.theme) private var theme

    private let image: String
    private let brand: LocalizedStringKey
    private let subtitle: LocalizedStringKey
    private let price: LocalizedStringKey
    private let originalPrice: LocalizedStringKey?
    private let discount: LocalizedStringKey?
    private let photoWidth: CGFloat
    private let photoHeight: CGFloat

    public init(
        image: String,
        brand: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        price: LocalizedStringKey,
        originalPrice: LocalizedStringKey? = nil,
        discount: LocalizedStringKey? = nil,
        photoWidth: CGFloat = 240,
        photoHeight: CGFloat = 311
    ) {
        self.image = image
        self.brand = brand
        self.subtitle = subtitle
        self.price = price
        self.originalPrice = originalPrice
        self.discount = discount
        self.photoWidth = photoWidth
        self.photoHeight = photoHeight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            // Photo
            Image(image, bundle: .main)
                .resizable()
                .scaledToFill()
                .frame(width: photoWidth, height: photoHeight)
                .background(theme.colors.surfaceNeutral2)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))

            // Name & Price
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                // Name
                VStack(alignment: .leading, spacing: 0) {
                    Text(brand)
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    Text(subtitle)
                        .font(theme.typography.tiny.font)
                        .tracking(theme.typography.tiny.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }

                // Price
                HStack(spacing: theme.spacing.xs) {
                    Text(price)
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    if let originalPrice = originalPrice {
                        Text(originalPrice)
                            .font(theme.typography.tinyRegular.font)
                            .tracking(theme.typography.tinyRegular.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                            .opacity(0.75)
                            .strikethrough()
                    }

                    if let discount = discount {
                        DSBadge(variant: .tagSemantic, text: discount)
                    }
                }
            }
            .padding(.leading, theme.spacing.sm)
            .padding(.top, theme.spacing.xxs)
        }
        .padding(.bottom, theme.spacing.sm)
    }
}

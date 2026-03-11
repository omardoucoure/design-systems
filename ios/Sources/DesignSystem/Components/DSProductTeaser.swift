import SwiftUI

// MARK: - DSProductTeaserItem

/// Data model for a single product in a teaser row.
public struct DSProductTeaserItem: Identifiable {
    public let id = UUID()
    public let image: String
    public let brand: LocalizedStringKey
    public let subtitle: LocalizedStringKey
    public let price: LocalizedStringKey
    public let originalPrice: LocalizedStringKey?
    public let discount: LocalizedStringKey?

    public init(
        image: String,
        brand: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        price: LocalizedStringKey,
        originalPrice: LocalizedStringKey? = nil,
        discount: LocalizedStringKey? = nil
    ) {
        self.image = image
        self.brand = brand
        self.subtitle = subtitle
        self.price = price
        self.originalPrice = originalPrice
        self.discount = discount
    }
}

// MARK: - DSProductTeaser

/// A horizontal scrolling row of product cards.
///
/// Figma: "Teaser" container — fixed height (400px), horizontal flex row,
/// gap 12, with product cards inside.
///
/// Usage:
/// ```swift
/// DSProductTeaser(products: [
///     DSProductTeaserItem(image: "photo1", brand: "Brand", subtitle: "Item", price: "$100")
/// ])
/// ```
public struct DSProductTeaser: View {
    @Environment(\.theme) private var theme

    private let products: [DSProductTeaserItem]
    private let height: CGFloat

    public init(
        products: [DSProductTeaserItem],
        height: CGFloat = 400
    ) {
        self.products = products
        self.height = height
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: theme.spacing.sm) {
                ForEach(products) { product in
                    DSProductCard(
                        image: product.image,
                        brand: product.brand,
                        subtitle: product.subtitle,
                        price: product.price,
                        originalPrice: product.originalPrice,
                        discount: product.discount
                    )
                }
            }
        }
        .frame(height: height)
    }
}

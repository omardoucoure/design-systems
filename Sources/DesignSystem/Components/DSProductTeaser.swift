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
/// Usage (modifier-based):
/// ```swift
/// DSProductTeaser(products: [
///     DSProductTeaserItem(image: "photo1", brand: "Brand", subtitle: "Item", price: "$100")
/// ])
/// .height(450)
/// ```
public struct DSProductTeaser: View {
    @Environment(\.theme) private var theme

    // Core params (init)
    private let _products: [DSProductTeaserItem]

    // Modifier params
    private var _height: CGFloat = 400

    /// Creates a product teaser row. Use `.height()` modifier to customize.
    public init(products: [DSProductTeaserItem]) {
        self._products = products
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use init(products:) with .height() modifier")
    public init(
        products: [DSProductTeaserItem],
        height: CGFloat = 400
    ) {
        self._products = products
        self._height = height
    }

    // MARK: - Modifiers

    /// Sets the fixed height of the teaser row. Default is 400.
    public func height(_ height: CGFloat) -> Self {
        var copy = self
        copy._height = height
        return copy
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: theme.spacing.sm) {
                ForEach(_products) { product in
                    DSProductCard(
                        image: product.image,
                        brand: product.brand,
                        subtitle: product.subtitle,
                        price: product.price
                    )
                    .originalPrice(product.originalPrice)
                    .discount(product.discount)
                }
            }
        }
        .frame(height: _height)
    }
}

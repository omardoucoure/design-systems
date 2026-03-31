import SwiftUI

// MARK: - DSProductCard

/// A product card with a photo, brand name, subtitle, price,
/// optional original price with strikethrough, and optional discount badge.
///
/// Figma: "1" / "2" product items inside "Teaser" rows.
///
/// Usage (modifier-based):
/// ```swift
/// DSProductCard(
///     image: "shop_product1",
///     brand: "Roa® Synthetic",
///     subtitle: "Hooded Down Jacket",
///     price: "$585"
/// )
/// .originalPrice("$590")
/// .discount("10%")
/// .photoSize(width: 140, height: 180)
/// ```
public struct DSProductCard: View {
    @Environment(\.theme) private var theme

    // Core params (init)
    private let _image: String
    private let _brand: LocalizedStringKey
    private let _subtitle: LocalizedStringKey
    private let _price: LocalizedStringKey

    // Modifier params
    private var _originalPrice: LocalizedStringKey?
    private var _discount: LocalizedStringKey?
    private var _photoWidth: CGFloat = 240
    private var _photoHeight: CGFloat = 311

    /// Creates a product card with core data. Use modifiers for optional properties.
    public init(
        image: String,
        brand: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        price: LocalizedStringKey
    ) {
        self._image = image
        self._brand = brand
        self._subtitle = subtitle
        self._price = price
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use init(image:brand:subtitle:price:) with .originalPrice(), .discount(), .photoSize() modifiers")
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
        self._image = image
        self._brand = brand
        self._subtitle = subtitle
        self._price = price
        self._originalPrice = originalPrice
        self._discount = discount
        self._photoWidth = photoWidth
        self._photoHeight = photoHeight
    }

    // MARK: - Modifiers

    /// Sets the original (pre-discount) price, shown with strikethrough.
    public func originalPrice(_ price: LocalizedStringKey?) -> Self {
        var copy = self
        copy._originalPrice = price
        return copy
    }

    /// Sets the discount badge text (e.g. "10%").
    public func discount(_ discount: LocalizedStringKey?) -> Self {
        var copy = self
        copy._discount = discount
        return copy
    }

    /// Sets the photo dimensions. Default is 240x311.
    public func photoSize(width: CGFloat, height: CGFloat) -> Self {
        var copy = self
        copy._photoWidth = width
        copy._photoHeight = height
        return copy
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            // Photo
            Image(_image, bundle: .main)
                .resizable()
                .scaledToFill()
                .frame(width: _photoWidth, height: _photoHeight)
                .background(theme.colors.surfaceNeutral2)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))

            // Name & Price
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                // Name
                VStack(alignment: .leading, spacing: 0) {
                    Text(_brand)
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    Text(_subtitle)
                        .font(theme.typography.tiny.font)
                        .tracking(theme.typography.tiny.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }

                // Price
                HStack(spacing: theme.spacing.xs) {
                    Text(_price)
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    if let originalPrice = _originalPrice {
                        Text(originalPrice)
                            .font(theme.typography.tinyRegular.font)
                            .tracking(theme.typography.tinyRegular.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                            .opacity(0.75)
                            .strikethrough()
                    }

                    if let discount = _discount {
                        DSBadge(.tagSemantic).text(discount)
                    }
                }
            }
            .padding(.leading, theme.spacing.sm)
            .padding(.top, theme.spacing.xxs)
        }
        .padding(.bottom, theme.spacing.sm)
    }
}

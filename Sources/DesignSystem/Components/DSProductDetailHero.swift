// figma-node: 87:96135
import SwiftUI

public enum DSProductDetailHeroStyle: Sendable, CaseIterable {
    case cardWithSizes
    case imageAbove
}

public struct DSProductDetailHero: View {
    @Environment(\.theme) private var theme

    private let _style: DSProductDetailHeroStyle
    private let _image: String
    private let _title: LocalizedStringKey
    private let _subtitle: LocalizedStringKey
    private let _price: LocalizedStringKey

    private var _originalPrice: LocalizedStringKey?
    private var _discount: LocalizedStringKey?
    private var _selectedSize: LocalizedStringKey = "43"
    private var _sizes: [LocalizedStringKey] = ["40", "41", "44", "45", "46"]
    private var _reviews: LocalizedStringKey?
    private var _quantity: Int = 1
    private var _pageCount: Int = 3
    private var _currentPage: Int = 0
    private var _onAddToCart: (() -> Void)?

    public init(
        style: DSProductDetailHeroStyle = .cardWithSizes,
        image: String,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        price: LocalizedStringKey
    ) {
        self._style = style
        self._image = image
        self._title = title
        self._subtitle = subtitle
        self._price = price
    }

    public func originalPrice(_ value: LocalizedStringKey?) -> Self {
        var copy = self
        copy._originalPrice = value
        return copy
    }

    public func discount(_ value: LocalizedStringKey?) -> Self {
        var copy = self
        copy._discount = value
        return copy
    }

    public func selectedSize(_ value: LocalizedStringKey) -> Self {
        var copy = self
        copy._selectedSize = value
        return copy
    }

    public func sizes(_ value: [LocalizedStringKey]) -> Self {
        var copy = self
        copy._sizes = value
        return copy
    }

    public func reviews(_ value: LocalizedStringKey?) -> Self {
        var copy = self
        copy._reviews = value
        return copy
    }

    public func quantity(_ value: Int) -> Self {
        var copy = self
        copy._quantity = value
        return copy
    }

    public func pages(count: Int, current: Int) -> Self {
        var copy = self
        copy._pageCount = count
        copy._currentPage = current
        return copy
    }

    public func onAddToCart(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onAddToCart = action
        return copy
    }

    private var metrics: ProductDetailHeroComponentTokens { theme.components.productDetailHero }

    public var body: some View {
        switch _style {
        case .cardWithSizes: cardWithSizesBody
        case .imageAbove: imageAboveBody
        }
    }

    // MARK: - CardWithSizes

    private var cardWithSizesBody: some View {
        HStack(alignment: .top, spacing: theme.spacing.sm) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                infoHeader
                sizeSelectorPill
                productImage
                pageDots
                DSButton("Add to Cart", style: .filledA, size: .big, icon: .cart, iconPosition: .right) {
                    _onAddToCart?()
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(theme.spacing.xl)
            .background(theme.colors.surfacePrimary100)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))

            sizeColumn
        }
    }

    private var infoHeader: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            VStack(alignment: .leading, spacing: 0) {
                Text(_title)
                    .font(theme.typography.largeBold.font)
                    .tracking(theme.typography.largeBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral05)
                Text(_subtitle)
                    .font(theme.typography.tiny.font)
                    .tracking(theme.typography.tiny.tracking)
                    .foregroundStyle(theme.colors.textNeutral05)
            }

            HStack(spacing: theme.spacing.xs) {
                Text(_price)
                    .font(theme.typography.largeBold.font)
                    .tracking(theme.typography.largeBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral05)

                if let originalPrice = _originalPrice {
                    Text(originalPrice)
                        .font(theme.typography.tinyRegular.font)
                        .tracking(theme.typography.tinyRegular.tracking)
                        .foregroundStyle(theme.colors.textNeutral05)
                        .opacity(theme.opacity.lg)
                        .strikethrough()
                }

                if let discount = _discount {
                    DSBadge(.numberSemantic).text(discount)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var sizeSelectorPill: some View {
        HStack(spacing: theme.spacing.sm) {
            Circle()
                .fill(theme.colors.warning)
                .frame(width: metrics.sizePillDotSize, height: metrics.sizePillDotSize)
            glyph(.arrowSeparateVertical, size: metrics.iconSize, color: theme.colors.textNeutral05)
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.vertical, theme.spacing.xs)
        .frame(width: metrics.sizePillWidth)
        .background(theme.colors.surfaceNeutral9)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.full))
    }

    private var productImage: some View {
        Image(_image, bundle: .main)
            .resizable()
            .scaledToFill()
            .frame(height: metrics.imageHeight)
            .frame(maxWidth: .infinity)
            .background(theme.colors.surfaceNeutral2)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
    }

    private var pageDots: some View {
        HStack(spacing: theme.spacing.xs) {
            ForEach(0..<_pageCount, id: \.self) { index in
                Capsule()
                    .fill(theme.colors.textNeutral05)
                    .frame(
                        width: index == _currentPage ? metrics.dotActiveWidth : metrics.dotSize,
                        height: metrics.dotSize
                    )
                    .opacity(index == _currentPage ? theme.opacity.full : metrics.inactivePageDotOpacity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var sizeColumn: some View {
        VStack(spacing: theme.spacing.lg) {
            ForEach(Array(_sizes.enumerated()), id: \.offset) { _, size in
                DSButton(size, style: .neutral, size: .small) {}
            }

            HStack(spacing: theme.spacing.xs) {
                glyph(.arrowLeftLong, size: metrics.stepperGlyphSize, color: theme.colors.textNeutral05)
                Text(_selectedSize)
                    .font(theme.typography.label.font)
                    .tracking(theme.typography.label.tracking)
                    .foregroundStyle(theme.colors.textNeutral05)
                glyph(.heart, size: metrics.stepperGlyphSize, color: theme.colors.textNeutral05)
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xxs)
            .background(theme.colors.surfacePrimary120)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.full))
        }
    }

    // MARK: - ImageAbove

    private var imageAboveBody: some View {
        VStack(spacing: theme.spacing.sm) {
            imageAboveHeroImage
            imageAboveInfoCard
        }
    }

    private var imageAboveHeroImage: some View {
        Image(_image, bundle: .main)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: metrics.imageHeight)
            .overlay(alignment: .topLeading) {
                iconPill(background: theme.colors.surfacePrimary100) {
                    glyph(.arrowLeftLong, size: metrics.stepperGlyphSize, color: theme.colors.textNeutral05)
                    glyph(.infoCircle, size: metrics.stepperGlyphSize, color: theme.colors.textNeutral05)
                }
                .padding(theme.spacing.xl)
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
    }

    private var imageAboveInfoCard: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            Text(_title)
                .font(theme.typography.h4.font)
                .tracking(theme.typography.h4.tracking)
                .foregroundStyle(theme.colors.textNeutral9)

            HStack(spacing: theme.spacing.xs) {
                HStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(dsIcon: .star)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: metrics.starSize, height: metrics.starSize)
                            .foregroundStyle(index == 4 ? theme.colors.infoFocus : theme.colors.warning)
                    }
                }
                .padding(theme.spacing.xs)
                .background(theme.colors.surfaceNeutral05)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))

                if let reviews = _reviews {
                    Text(reviews)
                        .font(theme.typography.smallRegular.font)
                        .tracking(theme.typography.smallRegular.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
            }

            HStack(spacing: theme.spacing.xs) {
                glyph(.minus, size: metrics.stepperGlyphSize, color: theme.colors.textNeutral05)
                Text("\(_quantity)")
                    .font(theme.typography.label.font)
                    .tracking(theme.typography.label.tracking)
                    .foregroundStyle(theme.colors.textNeutral05)
                glyph(.plus, size: metrics.stepperGlyphSize, color: theme.colors.textNeutral05)
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xxs)
            .background(theme.colors.surfacePrimary120)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.full))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(theme.spacing.xl)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .padding(.top, -metrics.imageHeight / 4)
    }

    // MARK: - Helpers

    private func iconPill<Content: View>(
        background: Color,
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        HStack(spacing: theme.spacing.sm, content: content)
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.xs)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.full))
    }

    private func glyph(_ icon: DSIcon, size: CGFloat, color: Color) -> some View {
        Image(dsIcon: icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(color)
    }
}

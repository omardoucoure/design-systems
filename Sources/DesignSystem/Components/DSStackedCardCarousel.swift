import SwiftUI

// MARK: - DSStackedCardCarouselItem

/// A single card in `DSStackedCardCarousel`.
public struct DSStackedCardCarouselItem: Identifiable {
    public let id = UUID()
    public let height: CGFloat
    public let image: String?
    public let backgroundColor: Color?
    public let showGradientOverlay: Bool

    /// Image card.
    public init(height: CGFloat, image: String) {
        self.height = height
        self.image = image
        self.backgroundColor = nil
        self.showGradientOverlay = false
    }

    /// Solid color card with optional gradient darkening overlay.
    public init(height: CGFloat, backgroundColor: Color, showGradientOverlay: Bool = false) {
        self.height = height
        self.image = nil
        self.backgroundColor = backgroundColor
        self.showGradientOverlay = showGradientOverlay
    }
}

// MARK: - DSStackedCardCarousel

/// A stack of overlapping cards arranged front-to-back with decreasing heights.
///
/// Figma: "Carousel" in [Navigation] 8 (node 481:14211)
///
/// Cards overlap horizontally by `overlap` points. The last item in the array
/// is the front (tallest) card.
///
/// Usage (modifier API):
/// ```swift
/// DSStackedCardCarousel(items: [
///     DSStackedCardCarouselItem(height: 320, backgroundColor: theme.colors.surfaceNeutral3, showGradientOverlay: true),
///     DSStackedCardCarouselItem(height: 420, backgroundColor: theme.colors.surfaceNeutral3),
///     DSStackedCardCarouselItem(height: 520, image: "carousel_front"),
/// ])
/// .carouselCardWidth(220)
/// .carouselOverlap(190)
/// .carouselContainerHeight(730)
/// ```
public struct DSStackedCardCarousel: View {
    @Environment(\.theme) private var theme

    // Core (init-only)
    private let items: [DSStackedCardCarouselItem]

    // Modifier-based visual customization
    private var _cardWidth: CGFloat = 220
    private var _overlap: CGFloat = 190
    private var _containerHeight: CGFloat = 730

    public init(items: [DSStackedCardCarouselItem]) {
        self.items = items
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSStackedCardCarousel(items:) with .carouselCardWidth(), .carouselOverlap(), .carouselContainerHeight() modifiers instead")
    public init(
        items: [DSStackedCardCarouselItem],
        cardWidth: CGFloat = 220,
        overlap: CGFloat = 190,
        containerHeight: CGFloat = 730
    ) {
        self.items = items
        self._cardWidth = cardWidth
        self._overlap = overlap
        self._containerHeight = containerHeight
    }

    // MARK: - Modifiers

    public func carouselCardWidth(_ width: CGFloat) -> Self {
        var copy = self
        copy._cardWidth = width
        return copy
    }

    public func carouselOverlap(_ overlap: CGFloat) -> Self {
        var copy = self
        copy._overlap = overlap
        return copy
    }

    public func carouselContainerHeight(_ height: CGFloat) -> Self {
        var copy = self
        copy._containerHeight = height
        return copy
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: -_overlap) {
            ForEach(items) { item in
                cardView(item)
            }
        }
        .frame(height: _containerHeight)
    }

    @ViewBuilder
    private func cardView(_ item: DSStackedCardCarouselItem) -> some View {
        if let image = item.image {
            Image(image, bundle: .main)
                .resizable()
                .scaledToFill()
                .frame(width: _cardWidth, height: item.height)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        } else {
            RoundedRectangle(cornerRadius: theme.radius.xl)
                .fill(item.backgroundColor ?? theme.colors.surfaceNeutral3)
                .frame(width: _cardWidth, height: item.height)
                .overlay(
                    Group {
                        if item.showGradientOverlay {
                            RoundedRectangle(cornerRadius: theme.radius.xl)
                                .fill(Color.black.opacity(0.1))
                        }
                    }
                )
        }
    }
}

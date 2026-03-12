import SwiftUI

// MARK: - DSStackedCardCarouselItem

/// A single card in `DSStackedCardCarousel`.
public struct DSStackedCardCarouselItem: Identifiable {
    public let id = UUID()
    public let height: CGFloat
    public let width: CGFloat?
    public let image: String?
    public let backgroundColor: Color?
    public let showGradientOverlay: Bool

    /// Image card.
    public init(height: CGFloat, width: CGFloat? = nil, image: String) {
        self.height = height
        self.width = width
        self.image = image
        self.backgroundColor = nil
        self.showGradientOverlay = false
    }

    /// Solid color card with optional gradient darkening overlay.
    public init(height: CGFloat, width: CGFloat? = nil, backgroundColor: Color, showGradientOverlay: Bool = false) {
        self.height = height
        self.width = width
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
/// Usage:
/// ```swift
/// DSStackedCardCarousel(
///     items: [
///         DSStackedCardCarouselItem(height: 320, backgroundColor: theme.colors.surfaceNeutral3, showGradientOverlay: true),
///         DSStackedCardCarouselItem(height: 420, backgroundColor: theme.colors.surfaceNeutral3),
///         DSStackedCardCarouselItem(height: 520, image: "carousel_front"),
///     ],
///     cardWidth: 220,
///     overlap: 190
/// )
/// ```
public struct DSStackedCardCarousel: View {
    @Environment(\.theme) private var theme

    private let items: [DSStackedCardCarouselItem]
    private let cardWidth: CGFloat
    private let overlap: CGFloat
    private let containerHeight: CGFloat

    public init(
        items: [DSStackedCardCarouselItem],
        cardWidth: CGFloat = 220,
        overlap: CGFloat = 190,
        containerHeight: CGFloat = 730
    ) {
        self.items = items
        self.cardWidth = cardWidth
        self.overlap = overlap
        self.containerHeight = containerHeight
    }

    public var body: some View {
        HStack(spacing: -overlap) {
            ForEach(items) { item in
                cardView(item)
            }
        }
        .frame(height: containerHeight)
    }

    @ViewBuilder
    private func cardView(_ item: DSStackedCardCarouselItem) -> some View {
        let w = item.width ?? cardWidth
        if let image = item.image {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: w, height: item.height)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        } else {
            RoundedRectangle(cornerRadius: theme.radius.xl)
                .fill(item.backgroundColor ?? theme.colors.surfaceNeutral3)
                .frame(width: w, height: item.height)
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

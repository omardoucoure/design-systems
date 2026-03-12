import SwiftUI

// MARK: - DSCarouselStyle

/// Defines the visual behaviour of a DSCarousel.
public enum DSCarouselStyle: Sendable {
    /// The focused card fills the full height; adjacent cards are scaled
    /// down vertically and centred, creating a spotlight / depth effect.
    /// Use for profile photo galleries, featured content, etc.
    case spotlight

    /// All cards are the same size — standard horizontal paging with peek.
    case standard
}

// MARK: - DSCarousel

/// A horizontal swipeable image carousel with rounded corners and a peek
/// effect. Pass a `DSCarouselStyle` to control the zoom behaviour.
///
/// Usage:
/// ```swift
/// // Spotlight: focused card full-height, others shrink
/// DSCarousel(images: ["photo-1", "photo-2"], currentIndex: $page, style: .spotlight)
///
/// // Standard: all cards same size
/// DSCarousel(images: ["photo-1", "photo-2"], currentIndex: $page, style: .standard)
/// ```
public struct DSCarousel: View {
    @Environment(\.theme) private var theme

    private let images: [String]
    @Binding private var currentIndex: Int
    private let style: DSCarouselStyle

    @GestureState private var dragOffset: CGFloat = 0

    private let peekWidth: CGFloat = 48
    private let spotlightInactiveScale: CGFloat = 0.85

    public init(
        images: [String],
        currentIndex: Binding<Int>,
        style: DSCarouselStyle = .spotlight
    ) {
        self.images = images
        self._currentIndex = currentIndex
        self.style = style
    }

    public var body: some View {
        GeometryReader { geo in
            let cardWidth = geo.size.width - peekWidth
            let spacing = theme.spacing.sm
            let step = cardWidth + spacing
            let baseOffset = -CGFloat(currentIndex) * step
            let totalOffset = baseOffset + dragOffset

            HStack(spacing: spacing) {
                ForEach(images.indices, id: \.self) { index in
                    let scale = cardScale(index: index, totalOffset: totalOffset, step: step)

                    Image(images[index], bundle: .main)
                        .resizable()
                        .scaledToFill()
                        .frame(width: cardWidth, height: geo.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
                        .scaleEffect(y: scale, anchor: .center)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                }
            }
            .offset(x: totalOffset)
            .animation(.easeInOut(duration: 0.3), value: currentIndex)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = cardWidth / 3
                        if value.translation.width < -threshold, currentIndex < images.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) { currentIndex += 1 }
                        } else if value.translation.width > threshold, currentIndex > 0 {
                            withAnimation(.easeInOut(duration: 0.3)) { currentIndex -= 1 }
                        }
                    }
            )
        }
        .clipped()
    }

    // MARK: - Scale

    private func cardScale(index: Int, totalOffset: CGFloat, step: CGFloat) -> CGFloat {
        switch style {
        case .standard:
            return 1.0
        case .spotlight:
            let progress = (totalOffset + CGFloat(index) * step) / step
            let distance = min(abs(progress), 1.0)
            return spotlightInactiveScale + (1.0 - spotlightInactiveScale) * (1.0 - distance)
        }
    }
}

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
/// effect. Use the `.carouselStyle()` modifier to control the zoom behaviour.
///
/// Usage (modifier-based):
/// ```swift
/// // Spotlight (default):
/// DSCarousel(images: ["photo-1", "photo-2"], currentIndex: $page)
///
/// // Standard:
/// DSCarousel(images: ["photo-1", "photo-2"], currentIndex: $page)
///     .carouselStyle(.standard)
/// ```
public struct DSCarousel: View {
    @Environment(\.theme) private var theme

    private let _images: [String]
    @Binding private var _currentIndex: Int
    private var _style: DSCarouselStyle = .spotlight

    @GestureState private var dragOffset: CGFloat = 0

    private let peekWidth: CGFloat = 48
    private let spotlightInactiveScale: CGFloat = 0.85

    // MARK: - Minimal init

    public init(images: [String], currentIndex: Binding<Int>) {
        self._images = images
        self.__currentIndex = currentIndex
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSCarousel(images:currentIndex:) with .carouselStyle() modifier instead")
    public init(
        images: [String],
        currentIndex: Binding<Int>,
        style: DSCarouselStyle
    ) {
        self._images = images
        self.__currentIndex = currentIndex
        self._style = style
    }

    // MARK: - Modifiers

    /// Sets the carousel visual style.
    public func carouselStyle(_ style: DSCarouselStyle) -> DSCarousel {
        var copy = self
        copy._style = style
        return copy
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geo in
            let cardWidth = geo.size.width - peekWidth
            let spacing = theme.spacing.sm
            let step = cardWidth + spacing
            let baseOffset = -CGFloat(_currentIndex) * step
            let totalOffset = baseOffset + dragOffset

            HStack(spacing: spacing) {
                ForEach(_images.indices, id: \.self) { index in
                    let scale = cardScale(index: index, totalOffset: totalOffset, step: step)

                    Image(_images[index], bundle: .main)
                        .resizable()
                        .scaledToFill()
                        .frame(width: cardWidth, height: geo.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
                        .scaleEffect(y: scale, anchor: .center)
                        .animation(.easeInOut(duration: 0.3), value: _currentIndex)
                }
            }
            .offset(x: totalOffset)
            .animation(.easeInOut(duration: 0.3), value: _currentIndex)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = cardWidth / 3
                        if value.translation.width < -threshold, _currentIndex < _images.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) { _currentIndex += 1 }
                        } else if value.translation.width > threshold, _currentIndex > 0 {
                            withAnimation(.easeInOut(duration: 0.3)) { _currentIndex -= 1 }
                        }
                    }
            )
        }
        .clipped()
    }

    // MARK: - Scale

    private func cardScale(index: Int, totalOffset: CGFloat, step: CGFloat) -> CGFloat {
        switch _style {
        case .standard:
            return 1.0
        case .spotlight:
            let progress = (totalOffset + CGFloat(index) * step) / step
            let distance = min(abs(progress), 1.0)
            return spotlightInactiveScale + (1.0 - spotlightInactiveScale) * (1.0 - distance)
        }
    }
}

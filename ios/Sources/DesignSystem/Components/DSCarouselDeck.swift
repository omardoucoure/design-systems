import SwiftUI

// MARK: - DoubleContainerModifier

/// Adds a two-layer stacked "deck" visual behind any view.
/// The two ghost cards peek below the content, giving a card-stack depth effect.
/// Based on Figma node 994-52157.
///
/// Usage:
/// ```swift
/// someView
///     .frame(height: 260)
///     .applyDoubleContainer(height: 260)
/// ```
struct DoubleContainerModifier: ViewModifier {
    @Environment(\.theme) private var theme

    let height: CGFloat

    /// How far the back ghost card peeks below the content.
    private let deckPeek: CGFloat = 48
    /// Horizontal insets matching Figma: 308px and 258px cards on a 375px screen.
    private let middleInset: CGFloat = 22
    private let backInset: CGFloat = 47

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            // Back ghost — narrowest, darkest (surfaceNeutral3 + 10% black overlay per Figma)
            RoundedRectangle(cornerRadius: theme.radius.xl)
                .fill(theme.colors.surfaceNeutral3)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radius.xl)
                        .fill(Color.black.opacity(0.1))
                )
                .frame(height: height + deckPeek)
                .padding(.horizontal, backInset)

            // Middle ghost — surfaceNeutral3 (lighter than back)
            RoundedRectangle(cornerRadius: theme.radius.xl)
                .fill(theme.colors.surfaceNeutral3)
                .frame(height: height + deckPeek / 2)
                .padding(.horizontal, middleInset)

            // The original content sits on top
            content
        }
        .frame(height: height + deckPeek)
        .frame(maxWidth: .infinity)
    }
}

extension View {
    /// Adds a two-layer stacked deck behind the view (Figma node 994-52157).
    /// - Parameter height: The height of the front content card.
    public func applyDoubleContainer(height: CGFloat) -> some View {
        modifier(DoubleContainerModifier(height: height))
    }
}

// MARK: - DSCarouselDeck

/// A swipeable photo carousel with the double-container deck effect applied.
///
/// Usage:
/// ```swift
/// @State private var page = 0
/// DSCarouselDeck(images: ["photo-1", "photo-2"], currentIndex: $page)
/// ```
public struct DSCarouselDeck: View {
    @Environment(\.theme) private var theme

    private let images: [String]
    @Binding private var currentIndex: Int
    private let cardHeight: CGFloat

    public init(
        images: [String],
        currentIndex: Binding<Int>,
        cardHeight: CGFloat = 260
    ) {
        self.images = images
        self._currentIndex = currentIndex
        self.cardHeight = cardHeight
    }

    public var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(images.indices, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: cardHeight)
        .applyDoubleContainer(height: cardHeight)
    }
}

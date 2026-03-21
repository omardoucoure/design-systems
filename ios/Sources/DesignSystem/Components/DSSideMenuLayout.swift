import SwiftUI

// MARK: - DSSideMenuLayout

/// A container that wraps any page content with a side drawer menu.
///
/// When the menu is closed, the content fills the full screen.
/// When open, the content slides right and scales down to become a "card",
/// with two shorter ghost cards appearing behind it — matching the
/// Figma [Navigation] 8 stacked carousel effect.
///
/// Usage:
/// ```swift
/// @State private var isMenuOpen = false
///
/// DSSideMenuLayout(isOpen: $isMenuOpen) {
///     DSNavigationMenu(items: menuItems, profile: profile)
/// } content: {
///     VStack {
///         DSTopAppBar(title: "Gallery", style: .smallCentered) { }
///             .overlay(alignment: .leading) {
///                 DSButton(style: .neutral, size: .medium, icon: .menuScale) {
///                     isMenuOpen.toggle()
///                 }
///             }
///     }
/// }
/// ```
public struct DSSideMenuLayout<Menu: View, Content: View>: View {
    @Environment(\.theme) private var theme

    @Binding private var isOpen: Bool
    private let menuWidth: CGFloat
    private let contentScale: CGFloat
    private let showBackgroundCards: Bool
    private let menu: () -> Menu
    private let content: () -> Content

    private let cardRadius: CGFloat = 32

    public init(
        isOpen: Binding<Bool>,
        menuWidth: CGFloat = 260,
        contentScale: CGFloat = 0.85,
        showBackgroundCards: Bool = true,
        @ViewBuilder menu: @escaping () -> Menu,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isOpen = isOpen
        self.menuWidth = menuWidth
        self.contentScale = contentScale
        self.showBackgroundCards = showBackgroundCards
        self.menu = menu
        self.content = content
    }

    // MARK: - State

    @GestureState private var dragOffset: CGFloat = 0

    private var effectiveOffset: CGFloat {
        isOpen ? menuWidth + dragOffset : max(0, dragOffset)
    }

    private var progress: CGFloat {
        min(max(effectiveOffset / menuWidth, 0), 1)
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // 0. Full-bleed background matching the menu area
                theme.colors.surfaceNeutral0_5
                    .ignoresSafeArea()

                // 1. Menu — always rendered, revealed as content slides right
                menu()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

                // 2. Ghost cards behind content
                if showBackgroundCards {
                    ghostCards(screenSize: geo.size)
                }

                // 3. Content (front card)
                contentCard
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isOpen)
        .ignoresSafeArea(.container, edges: .bottom)
    }

    // MARK: - Ghost Cards

    /// Two cards behind the content matching the Figma stacked carousel.
    /// Figma cards: 220w, overlap 190px (30px visible edge), radius 32.
    /// Heights: back=320 (62% of 520), middle=420 (81% of 520).
    /// Back card: surfaceNeutral3 + 10% black overlay. Middle: plain surfaceNeutral3.
    private func ghostCards(screenSize: CGSize) -> some View {
        let scale = 1.0 - (1.0 - contentScale) * progress
        let contentVisualW = screenSize.width * scale
        let contentVisualH = screenSize.height * scale

        let ghostW = contentVisualW

        // Figma height ratios: 320/520 ≈ 0.615, 420/520 ≈ 0.808
        let backH = contentVisualH * 0.615
        let middleH = contentVisualH * 0.808

        // Visible edge between each card — tight overlap like Figma
        let gap: CGFloat = 20.0 * progress
        let centerX = effectiveOffset

        return ZStack {
            // Back card (shortest) — surfaceNeutral3 + 10% black overlay
            RoundedRectangle(cornerRadius: cardRadius)
                .fill(theme.colors.surfaceNeutral3)
                .overlay(
                    RoundedRectangle(cornerRadius: cardRadius)
                        .fill(Color.black.opacity(0.1))
                )
                .frame(width: ghostW, height: backH)
                .offset(x: centerX - gap * 2)

            // Middle card — plain surfaceNeutral3
            RoundedRectangle(cornerRadius: cardRadius)
                .fill(theme.colors.surfaceNeutral3)
                .frame(width: ghostW, height: middleH)
                .offset(x: centerX - gap)
        }
        .opacity(Double(progress))
    }

    // MARK: - Content Card

    private var contentCard: some View {
        let scale = 1.0 - (1.0 - contentScale) * progress
        let radius = cardRadius * progress

        return content()
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .scaleEffect(scale)
            .offset(x: effectiveOffset)
            .shadow(
                color: .black.opacity(0.12 * progress),
                radius: 24,
                x: -8,
                y: 0
            )
            .gesture(dragGesture)
            .overlay(dimmerOverlay)
    }

    // MARK: - Dimmer Overlay

    @ViewBuilder
    private var dimmerOverlay: some View {
        if isOpen {
            Color.black.opacity(0.001)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isOpen = false
                    }
                }
        }
    }

    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .updating($dragOffset) { value, state, _ in
                let translation = value.translation.width
                if isOpen {
                    state = min(0, translation)
                } else {
                    state = max(0, translation)
                }
            }
            .onEnded { value in
                let translation = value.translation.width
                let velocity = value.predictedEndTranslation.width

                withAnimation(.easeInOut(duration: 0.3)) {
                    if isOpen {
                        if translation < -60 || velocity < -200 {
                            isOpen = false
                        }
                    } else {
                        if translation > 60 || velocity > 200 {
                            isOpen = true
                        }
                    }
                }
            }
    }
}

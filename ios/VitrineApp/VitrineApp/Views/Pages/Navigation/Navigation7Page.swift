import SwiftUI
import DesignSystem

// MARK: - Navigation7Page

/// Figma: [Navigation] 7 (node 481:14430)
///
/// Profile page with a bottom navigation overlay that appears when the
/// menu button (X) is tapped. The overlay shows full-width navigation
/// pills with a close button at the bottom.
struct Navigation7Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var showMenu = false
    @State private var carouselIndex = 0

    var body: some View {
        ZStack {
            // Background page content
            profileContent

            // Bottom navigation overlay
            if showMenu {
                DSBottomNavOverlay(
                    isPresented: $showMenu,
                    items: [
                        DSBottomNavOverlayItem(id: "messages", label: "Messages"),
                        DSBottomNavOverlayItem(id: "trending", label: "Trending"),
                        DSBottomNavOverlayItem(id: "bookmarks", label: "Bookmarks"),
                        DSBottomNavOverlayItem(id: "gallery", label: "Gallery"),
                        DSBottomNavOverlayItem(id: "settings", label: "Settings"),
                    ]
                )
                .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    // MARK: - Profile Content (Background)

    private var profileContent: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Top App Bar
                DSTopAppBar(title: "Profile", style: .smallCentered, onBack: { dismiss() }) {
                    DSButton(style: .neutral, size: .medium, icon: .menuScale) {}
                }

                ScrollView {
                    VStack(spacing: theme.spacing.lg) {
                        // Stacked card carousel — full width, no horizontal padding
                        carouselSection

                        // Page controls
                        DSPageControl(count: 5, currentIndex: $carouselIndex)

                        // Profile info card — with horizontal padding
                        profileInfoCard
                            .padding(.horizontal, theme.spacing.sm)
                    }
                    .padding(.bottom, 100)
                }
                .scrollIndicators(.hidden)
            }

            // X button at the bottom center — opens the menu
            DSButton(style: .filledC, size: .big, icon: .xmark) {
                withAnimation(.easeInOut(duration: 0.3)) { showMenu = true }
            }
            .padding(.bottom, theme.spacing.xl)
        }
        .background(theme.colors.surfaceNeutral0_5)
    }

    // MARK: - Carousel

    private var carouselSection: some View {
        GeometryReader { geo in
            let cardW = geo.size.width
            DSStackedCardCarousel(
                items: [
                    DSStackedCardCarouselItem(height: 260, image: "nav7_carousel"),
                    DSStackedCardCarouselItem(height: 260, backgroundColor: theme.colors.surfaceNeutral3),
                    DSStackedCardCarouselItem(height: 260, backgroundColor: theme.colors.surfaceNeutral3, showGradientOverlay: true),
                ],
                cardWidth: cardW,
                overlap: cardW - 30,
                containerHeight: 260
            )
        }
        .frame(height: 260)
        .padding(.horizontal, theme.spacing.sm)
        .clipped()
    }

    // MARK: - Profile Info Card

    private var profileInfoCard: some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Name & bio
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    DSText("Hristo Hristov",
                           style: theme.typography.h4, color: theme.colors.textNeutral9)

                    Text("Rockstar-in-training. Plays air guitar solos that even virtual fans cheer for.")
                        .font(theme.typography.caption.font)
                        .tracking(theme.typography.caption.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }

                // Social stats row
                HStack(spacing: 0) {
                    statColumn("1,200", label: "photos")

                    Rectangle()
                        .fill(theme.colors.textNeutral9)
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)

                    statColumn("2,980", label: "followers")

                    Rectangle()
                        .fill(theme.colors.textNeutral9)
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)

                    statColumn("1,600", label: "following")
                }
                .frame(height: 74)

                // CTA row
                HStack {
                    DSButton("Follow", style: .filledB, size: .medium, icon: .plus, iconPosition: .right) {}

                    Spacer()

                    DSButton("Message", style: .text, size: .medium, icon: .messageText, iconPosition: .right) {}
                }
            }
        }
    }

    // MARK: - Helpers

    private func statColumn(_ value: String, label: String) -> some View {
        VStack(spacing: 0) {
            Text(value)
                .font(theme.typography.largeSemiBold.font)
                .tracking(theme.typography.largeSemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral9)

            Text(label)
                .font(theme.typography.small.font)
                .tracking(theme.typography.small.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    Navigation7Page()
        .previewThemed()
}

import SwiftUI
import DesignSystem

// MARK: - Navigation8Page

/// Figma: [Navigation] 8 (node 481:14196)
///
/// Side navigation menu with a stacked card carousel on the right.
/// Menu shows icon+label rows with a profile row at the bottom.
/// Carousel displays three overlapping cards of increasing height
/// and overflows past the right screen edge.
struct Navigation8Page: View {
    @Environment(\.theme) private var theme

    var body: some View {
        HStack(alignment: .center, spacing: theme.spacing.md) {
            menu

            carousel
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.leading, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    // MARK: - Menu

    private var menu: some View {
        DSNavigationMenu(
            items: [
                DSNavigationMenuItem(id: "messages", label: "Messages", icon: .replyToMessage),
                DSNavigationMenuItem(id: "trending", label: "Trending", icon: .activity),
                DSNavigationMenuItem(id: "bookmarks", label: "Bookmarks", icon: .bookmark),
                DSNavigationMenuItem(id: "gallery", label: "Gallery", icon: .mediaImageList, isSelected: true),
                DSNavigationMenuItem(id: "settings", label: "Settings", icon: .settings),
                DSNavigationMenuItem(id: "notifications", label: "Notifications", icon: .bellNotification),
                DSNavigationMenuItem(id: "people", label: "People", icon: .group),
                DSNavigationMenuItem(id: "places", label: "Places", icon: .mapPin)
            ],
            profile: DSNavigationMenuProfile(
                image: "nav8_profile",
                name: "Hristo Hristov",
                subtitle: "Visual Designer"
            )
        )
    }

    // MARK: - Carousel

    private var carousel: some View {
        DSStackedCardCarousel(
            items: [
                DSStackedCardCarouselItem(
                    height: 320,
                    backgroundColor: theme.colors.surfaceNeutral3,
                    showGradientOverlay: true
                ),
                DSStackedCardCarouselItem(
                    height: 420,
                    backgroundColor: theme.colors.surfaceNeutral3
                ),
                DSStackedCardCarouselItem(
                    height: 520,
                    image: "nav8_carousel"
                )
            ]
        )
    }
}

#Preview {
    Navigation8Page()
        .previewThemed()
}

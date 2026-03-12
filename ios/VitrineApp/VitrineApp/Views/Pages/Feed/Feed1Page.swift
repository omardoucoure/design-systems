import SwiftUI
import DesignSystem

// MARK: - Feed1Page

/// Figma: [Feed] 1 (node 399:10796)
///
/// A social feed page with a top app bar, scrolling feed posts,
/// and a floating bottom app bar.
struct Feed1Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var isMenuOpen = false
    @State private var selectedTab = "home"

    private let bottomBarItems: [DSBottomBarItem] = [
        DSBottomBarItem(id: "home", label: "Home", icon: .home),
        DSBottomBarItem(id: "profile", label: "Profile", icon: .user),
        DSBottomBarItem(id: "calendar", label: "Calendar", icon: .calendar),
        DSBottomBarItem(id: "notifications", label: "Notifications", icon: .bell),
    ]

    var body: some View {
        DSSideMenuLayout(isOpen: $isMenuOpen) {
            sideMenuContent
        } content: {
            feedContent
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    // MARK: - Side Menu

    private var sideMenuContent: some View {
        DSNavigationMenu(
            items: [
                DSNavigationMenuItem(id: "feed", label: "Feed", icon: .mediaImageList, isSelected: true),
                DSNavigationMenuItem(id: "messages", label: "Messages", icon: .replyToMessage),
                DSNavigationMenuItem(id: "trending", label: "Trending", icon: .activity),
                DSNavigationMenuItem(id: "bookmarks", label: "Bookmarks", icon: .bookmark),
                DSNavigationMenuItem(id: "settings", label: "Settings", icon: .settings),
                DSNavigationMenuItem(id: "notifications", label: "Notifications", icon: .bellNotification),
                DSNavigationMenuItem(id: "people", label: "People", icon: .group),
                DSNavigationMenuItem(id: "places", label: "Places", icon: .mapPin),
            ],
            profile: DSNavigationMenuProfile(
                image: "feed1_avatar1",
                name: "Hristo Hristov",
                subtitle: "Content Creator"
            )
        )
        .padding(.leading, theme.spacing.sm)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(theme.colors.surfaceNeutral0_5)
    }

    // MARK: - Feed Content

    private var feedContent: some View {
        ZStack(alignment: .bottom) {
            theme.colors.surfaceNeutral0_5
                .ignoresSafeArea()

            VStack(spacing: 0) {
                DSTopAppBar(title: "Feed", style: .smallCentered, onBack: nil) {
                    DSButton(style: .neutral, size: .medium, icon: .search) {}
                }
                .overlay(alignment: .leading) {
                    DSButton(style: .neutral, size: .medium, icon: .menuScale) {
                        withAnimation(.easeInOut(duration: 0.3)) { isMenuOpen.toggle() }
                    }
                    .padding(.leading, theme.spacing.sm)
                }

                ScrollView {
                    VStack(spacing: theme.spacing.sm) {
                        DSFeedPost(
                            avatar: "feed1_avatar1",
                            avatarSize: CGSize(width: 56, height: 40),
                            name: "Hristo Hristov",
                            time: "2h ago",
                            likeCount: "2K",
                            commentCount: "26",
                            images: [
                                DSFeedPostImage(image: "feed1_photo1", isMain: true),
                                DSFeedPostImage(image: "feed1_photo2"),
                            ],
                            horizontalPadding: theme.spacing.sm
                        )

                        DSFeedPost(
                            avatar: "feed1_avatar2",
                            avatarSize: CGSize(width: 56, height: 40),
                            name: "Mila Valentino",
                            time: "6h ago",
                            likeCount: "2K",
                            commentCount: "26",
                            images: [
                                DSFeedPostImage(image: "feed1_photo3", isMain: true),
                                DSFeedPostImage(image: "feed1_photo4"),
                            ],
                            horizontalPadding: theme.spacing.sm
                        )
                    }
                    .padding(.bottom, 100)
                }
            }

            DSBottomAppBar(
                items: bottomBarItems,
                selectedId: $selectedTab,
                style: .floating,
                fabIcon: .plus
            )
            .padding(.horizontal, theme.spacing.md)
            .padding(.bottom, theme.spacing.lg)
        }
    }
}

#Preview {
    Feed1Page()
        .previewThemed()
}

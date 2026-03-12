import SwiftUI
import DesignSystem

// MARK: - Alert2Page

/// Figma: [Alerts] 2 (node 1025:89301)
///
/// Profile page with camera access alert card,
/// top app bar (back + title + menu), and bottom app bar.
struct Alert2Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var isMenuOpen = false
    @State private var selectedTab = "user"

    private let bottomBarItems = [
        DSBottomBarItem(id: "home", label: "Home", icon: .home),
        DSBottomBarItem(id: "graph", label: "Stats", icon: .graphUp),
        DSBottomBarItem(id: "calendar", label: "Calendar", icon: .calendar),
        DSBottomBarItem(id: "user", label: "Profile", icon: .user),
    ]

    var body: some View {
        DSSideMenuLayout(isOpen: $isMenuOpen) {
            sideMenuContent
        } content: {
            mainContent
        }
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }

    private var sideMenuContent: some View {
        DSNavigationMenu(
            items: [
                DSNavigationMenuItem(id: "profile", label: "Profile", icon: .user, isSelected: true),
                DSNavigationMenuItem(id: "messages", label: "Messages", icon: .replyToMessage),
                DSNavigationMenuItem(id: "bookmarks", label: "Bookmarks", icon: .bookmark),
                DSNavigationMenuItem(id: "settings", label: "Settings", icon: .settings),
                DSNavigationMenuItem(id: "notifications", label: "Notifications", icon: .bellNotification),
                DSNavigationMenuItem(id: "people", label: "People", icon: .group),
            ],
            profile: DSNavigationMenuProfile(
                image: "nav8_profile",
                name: "Hristo Hristov",
                subtitle: "Visual Designer"
            )
        )
        .padding(.leading, theme.spacing.sm)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(theme.colors.surfaceNeutral0_5)
    }

    private var mainContent: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: theme.spacing.sm) {
                DSTopAppBar(title: "Profile", style: .smallCentered, onBack: { dismiss() }) {
                    DSButton(style: .neutral, size: .medium, icon: .menuScale) {
                        withAnimation(.easeInOut(duration: 0.3)) { isMenuOpen.toggle() }
                    }
                }

                ScrollView {
                    DSCard(
                        background: theme.colors.surfaceNeutral2,
                        radius: theme.radius.xl,
                        padding: theme.spacing.xl
                    ) {
                        VStack(alignment: .leading, spacing: theme.spacing.xl) {
                            HStack {
                                DSIconImage(.mediaImagePlus, size: 40, color: theme.colors.textNeutral9)
                                Spacer()
                                DSButton(style: .neutralLight, size: .medium, icon: .xmark) {}
                            }

                            DSText("Chase down that beloved snapshot!",
                                   style: theme.typography.display2, color: theme.colors.textNeutral9)

                            DSDivider(style: .fullBleed)

                            DSText("With just a few taps, you can snap up and upload your star-studded profile pic.",
                                   style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)

                            DSCard(
                                background: theme.colors.surfacePrimary120,
                                radius: theme.radius.xl,
                                padding: theme.spacing.xl
                            ) {
                                HStack(spacing: theme.spacing.lg) {
                                    DSText("Let's Access Your Camera?",
                                           style: theme.typography.label, color: theme.colors.textNeutral0_5)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    DSButton(
                                        "Go!",
                                        style: .filledB,
                                        size: .medium,
                                        icon: .camera,
                                        iconPosition: .right
                                    ) {}
                                }
                            }
                        }
                    }
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.bottom, 100)
                }
            }

            DSBottomAppBar(
                items: bottomBarItems,
                selectedId: $selectedTab,
                style: .full,
                fabIcon: .plus,
                onFabTap: {}
            )
        }
        .background(theme.colors.surfaceNeutral0_5)
    }
}

#Preview {
    Alert2Page()
        .previewThemed()
}

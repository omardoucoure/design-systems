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

    var body: some View {
        DSSideMenuLayout(isOpen: $isMenuOpen) {
            sideMenuContent
        } content: {
            mainContent
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    private var sideMenuContent: some View {
        DSNavigationMenu(items: [
                DSNavigationMenuItem(id: "profile", label: "Profile", icon: .user, isSelected: true),
                DSNavigationMenuItem(id: "messages", label: "Messages", icon: .replyToMessage),
                DSNavigationMenuItem(id: "bookmarks", label: "Bookmarks", icon: .bookmark),
                DSNavigationMenuItem(id: "settings", label: "Settings", icon: .settings),
                DSNavigationMenuItem(id: "notifications", label: "Notifications", icon: .bellNotification),
                DSNavigationMenuItem(id: "people", label: "People", icon: .group),
            ])
            .profile(DSNavigationMenuProfile(
                image: "nav8_profile",
                name: "Hristo Hristov",
                subtitle: "Visual Designer"
            ))
        .padding(.leading, theme.spacing.sm)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
    }

    private var mainContent: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Profile") {
                DSButton {
                    withAnimation(.easeInOut(duration: 0.3)) { isMenuOpen.toggle() }
                }.buttonStyle(.neutral).buttonSize(.medium).icon(.menuScale)
            }.appBarStyle(.smallCentered).onBack { dismiss() }

            ScrollView {
                DSCard {
                    VStack(alignment: .leading, spacing: theme.spacing.xl) {
                        HStack {
                            DSIconImage(.mediaImagePlus, size: 40, color: theme.colors.textNeutral9)
                            Spacer()
                            DSButton { }
                                .buttonStyle(.neutralLight).buttonSize(.medium).icon(.xmark)
                        }

                        DSText("Chase down that beloved snapshot!",
                               style: theme.typography.display2, color: theme.colors.textNeutral9)

                        DSDivider()

                        DSText("With just a few taps, you can snap up and upload your star-studded profile pic.",
                               style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)

                        DSCard {
                            HStack(spacing: theme.spacing.lg) {
                                DSText("Let's Access Your Camera?",
                                       style: theme.typography.label, color: theme.colors.textNeutral05)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                DSButton("Go!") { }
                                    .buttonSize(.medium)
                                    .icon(.camera, position: .right)
                            }
                        }
                        .cardBackground(theme.colors.surfacePrimary120)
                    }
                }
                .padding(.horizontal, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
    }
}

#Preview {
    Alert2Page()
        .previewThemed()
}
